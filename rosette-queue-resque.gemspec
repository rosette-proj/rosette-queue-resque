$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'rosette/queuing/resque-queue/version'

Gem::Specification.new do |s|
  s.name     = "rosette-queue-resque"
  s.version  = ::Rosette::Queuing::ResqueQueue::VERSION
  s.authors  = ["Cameron Dutro"]
  s.email    = ["camertron@gmail.com"]
  s.homepage = "http://github.com/rosette-proj/rosette-queue-resque"

  s.description = s.summary = "A Resque queue backend for Rosette."

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'resque', '~> 1.25'
  s.add_dependency 'resque-scheduler', '~> 4.0'
  s.add_dependency 'rake'

  s.require_path = 'lib'
  s.files = Dir["{lib,spec}/**/*", "Gemfile", "History.txt", "README.md", "Rakefile", "rosette-queue-resque.gemspec"]
end
