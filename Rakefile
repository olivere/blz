# Rakefile for BLZ. -*-ruby-*
require 'rake/task'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/test*.rb']
end

desc "Run all tests"
task :default => [:test]

desc "Generate RDoc documentation"
task :rdoc do
  sh(*%w{rdoc --line-numbers --main README
              --title 'BLZ Documentation'
              --charset utf-8 -U -o doc} +
              %w{README} + Dir["lib/**/*.rb"])
end

desc "Make binaries executable"
task :chmod do
  Dir["bin/*"].each { |binary| File.chmod(0775, binary) }
end

desc "Start an IRB session with gem preloaded"
task :console do
  require 'irb'
  require 'irb/completion'

  $:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
  require 'blz'

  ARGV.clear
  IRB.start
end
