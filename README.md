[Homepage](http://rubyworks.github.com/autoload) /
[Report Issue](http://github.com/rubyworks/autoload/issues) /
[Source Code](http://github.com/rubyworks/autoload)
( [![Build Status](https://travis-ci.org/rubyworks/autoload.png)](https://travis-ci.org/rubyworks/autoload) )


# [Autoload](#description)

Offical word has it [autoload is dead](http://www.ruby-forum.com/topic/3036681).

But like James Brown, **"Autoload is alive!"**


## [Instructions](#instructions)

It works just like the good old `autoload` we have always loved.

Let's say we have a dependency on a library called "splinter", but it is only
used in special cases, so it would be good to only load it when needed. 

```ruby
  autoload :Splinter, 'splinter'
```

Now, as soon as we try to access the `Splinter` constant the `splinter`
library will be loaded.

```ruby
  Splinter
```

Autoload can be used relative to existing namespaces as well. For instance,
Bundler [uses it](https://github.com/carlhuda/bundler/blob/master/lib/bundler.rb)
to load it's own scripts.

```ruby
  module Bundler
    # ...
    autoload :Definition, 'bundler/definition'
    autoload :Dependency, 'bundler/dependency'
    autoload :DepProxy, 'bundler/dep_proxy'
    autoload :Deprecate, 'bundler/deprecate'
    autoload :Dsl, 'bundler/dsl'
    # ...
  end
```


## [Limitations](#limitations)

* Autoload is not thread safe. You need thread safe autoload? Submit a patch, please.
* Other libraries that redefine Module#const_missing may clobber autload's.


## [Copyrights](#copyrights)

Autoload is copyrighted open-source software.

    Copyright (c) 2013 Rubyworks

It can be modified and redistributed in accordance with the **BSD-2-Clause** license.

See [LICENSE.txt](https://github.com/rubyworks/autoload/blob/0.1.0/LICENSE.txt) for license details.
