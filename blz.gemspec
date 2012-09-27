# -*- encoding: utf-8 -*-
#require File.expand_path('../lib/money', __FILE__)

extra_rdoc_files = ['CHANGELOG.md', 'LICENSE', 'README.md']

Gem::Specification.new do |s|
  s.name            = 'blz'
  s.version         = '0.1.0'
  s.platform        = Gem::Platform::RUBY
  s.summary         = "BLZ (Bankleitzahlen) for Ruby"

  s.description = <<-EOF
BLZ (Bankleitzahlen) is a small library for looking up
the widely used bank identifier code system in Germany
and Austria.

http://github.com/olivere/blz
EOF

  s.author          = 'Oliver Eilhard'
  s.email           = 'oliver.eilhard@gmail.com'
  s.homepage        = 'http://github.com/olivere/blz'

  s.files           = `git ls-files`.split("\n") - [".gitignore"]
  s.bindir          = 'bin'
  s.executables     << 'blz'
  s.require_path    = 'lib'
  s.has_rdoc        = true
  s.extra_rdoc_files = extra_rdoc_files
  s.test_files      = []

  s.add_development_dependency("bundler", "~> 1.2")
  s.add_development_dependency("rdoc", "~> 2.5")
  s.add_development_dependency("rake", ">= 0.9")
end

