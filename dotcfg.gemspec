Gem::Specification.new do |s|
  s.name = 'dotcfg'
  s.summary = 'simple filesystem de/serialization for app configs'
  s.author = 'Rick Hull'
  s.homepage = 'https://github.com/rickhull/dotcfg'
  s.license = 'MIT'
  s.description = 'JSON and YAML config serialization and persistence'
  s.files = %w{Rakefile lib/dotcfg.rb}
  s.add_runtime_dependency 'json', '~> 1'
  s.add_development_dependency 'buildar', '~> 2'

  # set version dynamically from version file contents
  this_dir = File.expand_path('..', __FILE__)
  version_file = File.join(this_dir, 'VERSION')
  s.version  = File.read(version_file).chomp
end
