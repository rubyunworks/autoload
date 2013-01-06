## Module#autoload

An autoload can be used within a module for constants relative to its namespace. 

    module ::And
      autoload :Me, 'andme'
    end

    ::And::Me  #=> true

