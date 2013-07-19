require 'buildar'
require 'rake/testtask'

Buildar.new do |b|
  b.gemspec.name = 'dotcfg'
  b.gemspec.summary = 'simple filesystem de/serialization for app configs'
  b.gemspec.author = 'Rick Hull'
  b.gemspec.license = 'MIT'
  b.gemspec.description = 'JSON and YAML config serialization and synch'
  b.gemspec.files = %w{rakefile.rb lib/dotcfg.rb}
  b.gemspec.version = '0.0.1'
end
