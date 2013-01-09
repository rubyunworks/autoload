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
  $AUTOLOAD["Object::#{cname}".to_sym] << path
end

#
# Returns files paths to load if name is registered as autoload.
#
# @param [#to_sym] cname
#   The constant's name.
#
# @return [Array] Paths that would be required.
#
def self.autoload?(cname)
  $AUTOLOAD["Object::#{cname}".to_sym]
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
    self.class.autoload(cname, path)
  end

  #
  # Returns files paths to load if name is registered as autoload.
  #
  # @param [#to_sym] cname
  #   The constant's name.
  #
  # @return [Array] Paths that would be required.
  #
  def self.autoload?(cname)
    self.class.autoload?(cname, path)
  end
end

class Module
  #
  # Module/Class level autoload method.
  #
  # @param [#to_sym] cname 
  #   The constant's name.
  #
  # @param [String] path
  #   File path to require.
  #
  # @return [String] The $AUTOLOAD table.
  #
  def autoload(cname, path)
    $AUTOLOAD["#{name}::#{cname}".to_sym] << path
  end

  #
  # Returns files paths to load if name is registered as autoload.
  #
  # @param [#to_sym] cname
  #   The constant's name.
  #
  # @return [Array] Paths that would be required.
  #
  def self.autoload?(cname)
    $AUTOLOAD["#{name}::#{cname}".to_sym]
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
    key, term, search, key = nil, name, []

    # if module has no name, try to parse out a namespace from #insepct.
    # (yes, this is a hack!)
    unless term
      if /#<Class:(.*?)>/ =~ self.inspect
        term = $1
      end
    end

    # constant might be in the module nesting
    # (too bad https://bugs.ruby-lang.org/issues/3773 was rejected)
    if term
      parts = term.to_s.split('::')
      until parts.empty?
        search << parts.join('::')
        parts.pop
      end
    end

    # constant might be in ancestors
    search += ancestors.map{ |anc| anc.name }

    # look for match in $AUTOLOAD table
    search.each do |const| 
      if $AUTOLOAD.key?("#{const}::#{cname}".to_sym)
        key = "#{const}::#{cname}".to_sym
        break
      end
    end

    if key
      paths = $AUTOLOAD.delete(key)
      paths.each{ |path|  require(path) }
      begin
        eval(key.to_s, TOPLEVEL_BINDING)
        #Object.const_get(key)  # Ruby 2.0+
      rescue NameError
        const_missing_without_autoload(cname)
      end
    else
      const_missing_without_autoload(cname)
    end
  end

end
