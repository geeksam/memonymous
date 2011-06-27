# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "memonymous/version"

Gem::Specification.new do |s|
  s.name        = "memonymous"
  s.version     = Memonymous::VERSION
  s.authors     = ["Sam Livingston-Gray"]
  s.email       = ["geeksam@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Yet another memoizing gem.  This one doesn't pollute your method namespace.}
  s.description = %q{VERY SIMPLISTIC memoization for functions (one memoized value per function; no regard for arguments). Uses UnboundMethods instead of method aliasing, so you don't see extra method names when you inspect your object.}

  s.rubyforge_project = "memonymous"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
