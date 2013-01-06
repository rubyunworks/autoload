# Autoload

Autoload is a very simple library. The programmer specifies the files to be required
when an unknown constant is first used, and Autoload will automatically load it 
and return the newly found constant. (Note we are only using `Object` here to avoid
an issue with QED b/c it evaluates this code within a special module).

    Object::autoload 'TryMe', 'tryme'

Even though we haven't yet required "tryme", we should have no problem
access the the TryMe constant which is defined in this file.

    ::TryMe.assert == true

