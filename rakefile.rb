require 'buildar'
require 'rake/testtask'

Buildar.new do |b|
  b.use_git = true
  b.version_file = 'VERSION'
  b.gemspec.name = 'dotcfg'
  b.gemspec.summary = 'simple filesystem de/serialization for app configs'
  b.gemspec.homepage = 'https://github.com/rickhull/dotcfg'
  b.gemspec.author = 'Rick Hull'
  b.gemspec.license = 'MIT'
  b.gemspec.description = 'JSON and YAML config serialization and persistence'
  b.gemspec.files = %w{rakefile.rb lib/dotcfg.rb}
  b.gemspec.add_runtime_dependency 'json', '~> 1'
end
