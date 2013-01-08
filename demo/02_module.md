## Module#autoload

Autoload can be used within a module for constants relative to its namespace. 

    module ::And
      autoload :Me, 'andme'
    end

    ::And::Me  #=> true

Note we have to the toplevel indicators here b/c `require 'andme'` will load
the `And` module into the toplevel, but QED executes demos in a special 
module's scope (which emulates the toplevel, but as can be seen from this
demo, it is not possible to do so perfectly.)

