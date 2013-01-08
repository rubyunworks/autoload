# RELEASE HISTORY

## 0.3.0 / 2013-01-08

Turns out calling `super` in `#const_missing` was a bug. Instead it needed to
alias the old `#const_missing` and call that instead. Also, turned out the
`Object.const_missing` definition wasn't needed. Seems Toplevel's proxy knows
to look in Module for that.

Changes:

* Use alias instead of super call in Module#cont_missing.
* Remove Object.const_missing.


## 0.2.0 / 2013-01-06

Fixed broken namespace autoloads --damn thing seems rather tricker
than it should, but that's not atypical for Ruby at this level of
metaprogramming. Also tossed in `setup.rb` script, so autoload can 
be installed to act like an old-school standard library.

Changes:

* Fix issue with namespaced autoloads.
* Add setup.rb script to project.


## 0.1.0 / 2013-01-05

Honestly, I did not want to create this project, but sometimes the gods won't
hear our prayers. So we just have to take matters into our own hands.

Changes:

* Autoload is alive!

