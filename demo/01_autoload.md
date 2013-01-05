# Autoload

Autoload is a very simple library. The programmer specifies the files to be required
when an unknown constant is first used, and Autoload will automatically load it 
and return the newly found constant.

    autoload 'TryMe', 'tryme'

Even though we haven't yet required "tryme", we should have no problem
access the the TryMe constant which is defined in this file.

    TryMe  #=> true

That's pretty much it. The other point is that this autload can be used within 
a module for constants relative to its namespace. 

