# Broken 

Unfortunately, here is what will not work. And there seems to way to overcome.

    autoload :Broken, 'broken'

    module ::Broken
    end

    ::Broken.broke?

The problem is that `module Broken`, or `class Broken` for that matter, will
not trigger the `const_missing` hook. Whereas Ruby's built-in autoload would
be triggered.

