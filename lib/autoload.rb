$AUTOLOAD = Hash.new{ |h, k| h[k] = [] }

#
#
#
def self.autoload(name, path)
  $AUTOLOAD[name.to_sym] << path
end

class Module
  #
  #
  #
  def self.autoload(subname, path)
    $AUTOLOAD["#{name}::#{subname}".to_sym] << path
  end
end

module Kernel
  #
  # Note: I am not so certain the instance level method is a good idea.
  # The end used can just as easily and more cleary use `self.class.autoload`
  # to do it themselves.
  #
  def autoload(subname, path)
    $AUTOLOAD["#{self.class.name}::#{subname}".to_sym] << path
  end
end

class Object
  #
  #
  #
  def self.const_missing(name)
    if paths = $AUTOLOAD.delete(name)
      paths.each do |path|
        require(path)
      end
      super(name) unless const_defined?(name)
      const_get(name)
    else
      super(name)
    end
  end
end

