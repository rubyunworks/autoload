$AUTOLOAD = Hash.new{ |h, k| h[k] = [] }

#
# Toplevel autoload.
#
def self.autoload(cname, path)
  $AUTOLOAD[[Object, cname.to_sym]] << path
end

class Object
  #
  #
  #
  def self.const_missing(name)
    if paths = $AUTOLOAD.delete([self, name])
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

class Module
  #
  # Module autoload.
  #
  def autoload(cname, path)
    $AUTOLOAD[[self, cname.to_sym]] << path
  end

  #
  #
  #
  def const_missing(name)
    if paths = $AUTOLOAD.delete([self, name])
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

class Class
  #
  # We define autoload on Class too, just to be sure.
  #
  def autoload(cname, path)
    $AUTOLOAD[[self, cname.to_sym]] << path
  end
end

module Kernel
  #
  # Note: I am not so certain the instance level method is a good idea.
  # The end used can just as easily and more cleary use `self.class.autoload`
  # to do it themselves.
  #
  def autoload(cname, path)
    $AUTOLOAD[[self.class, cname.to_sym]] << path
  end
end

