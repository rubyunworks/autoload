# Broken 

Unfortunately, here is what will not work. And there seems to be no way
to overcome.

    autoload :BrokenModule, 'broken'

    module ::BrokenModule
    end

    ::BrokenModule.broke?

The problem is that `module Broken` will not trigger the `const_missing` hook.
Whereas Ruby's built-in autoload would be triggered.

On the other hand, we were able to use the `Object.inherited` callback to deal
with the same issue with `class`.

    autoload :BrokenClass, 'broken'

    module ::BrokenClass
    end

    ::BrokenClass.broke?

