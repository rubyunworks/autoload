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
  # Check the $AUTOLOAD table for a `[self, name]` entry. If present,
  # require file and try to get the constant again.
  #
  # @param [#to_sym] cname 
  #   The constants name.
  #
  def const_missing(name)
    if paths = $AUTOLOAD.delete([self, name])
      paths.each do |path|
        require(path)
      end
      const_missing_without_autoload(name) unless const_defined?(name)
      const_get(name)
    else
      const_missing_without_autoload(name)
    end
  end

end

