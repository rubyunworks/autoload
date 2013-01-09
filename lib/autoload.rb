# Global table to track constants that need to be autoloaded if accessed.
$AUTOLOAD = Hash.new{ |h, k| h[k] = [] }

#
# Toplevel autoload method.
#
# @param [#to_sym] cname 
#   The constants name.
#
# @param [String] path
#   File path to require.
#
# @return [String] The $AUTOLOAD table.
#
def self.autoload(cname, path)
  $AUTOLOAD[[Object, cname.to_sym]] << path
end

module Kernel
  #
  # Instance level autoload method.
  #
  # Note: I am not so certain the instance level method is a good idea.
  # The end used can just as easily and more cleary use `self.class.autoload`
  # to do it themselves. Nonetheless, Ruby supported this so we will too.
  #
  # @param [#to_sym] cname 
  #   The constants name.
  #
  # @param [String] path
  #   File path to require.
  #
  # @return [String] The $AUTOLOAD table.
  #
  def autoload(cname, path)
    $AUTOLOAD[[self.class, cname.to_sym]] << path
  end
end

class Module
  #
  # Module/Class level autoload method.
  #
  # @param [#to_sym] cname 
  #   The constants name.
  #
  # @param [String] path
  #   File path to require.
  #
  # @return [String] The $AUTOLOAD table.
  #
  def autoload(cname, path)
    $AUTOLOAD[[self, cname.to_sym]] << path
  end

 private

  alias :const_missing_without_autoload :const_missing

  #
  # Check the $AUTOLOAD table for expected constant. If present, require paths
  # associated with it and then try to get the constant again.
  #
  # @param [#to_sym] cname 
  #   The constants name.
  #
  # @return [Object] Constant's value.
  #
  def const_missing(cname)
    parent = nil

    # if constant is expected in this module
    if $AUTOLOAD.key?([self, cname])
      parent = self
    end

    # if constant is expected within this modules nesting
    # (too bad https://bugs.ruby-lang.org/issues/3773 was rejected)
    unless parent
      parts = name.to_s.split('::')
      parts.pop
      until parts.empty?
        const = Object.const_get(parts.join('::'))
        if $AUTOLOAD.key?([const, cname])
          parent = const
          break
        end
        parts.pop
      end
    end

    # if constant is expected in this modules ancestors.
    unless parent
      ancestors.each do |anc|
        if $AUTOLOAD.key?([anc, cname])
          parent = anc
          break
        end
      end
    end

    # if module has no name, try to parse out a namespace from #insepct.
    # (yes, this is a hack!)
    unless parent
      if name.nil?
        if /#<Class:(.*?)>/ =~ self.inspect
          parent = Object.const_get($1) rescue nil
        end
      end
    end

    if parent
      paths = $AUTOLOAD.delete([parent, cname])
      paths.each do |path|
        require(path)
      end
      #const_missing_without_autoload(cname) unless parent.const_defined?(cname)
      parent.const_get(cname) rescue const_missing_without_autoload(cname)
    else
      const_missing_without_autoload(cname)
    end
  end

end
