Gem::Specification.new do |s|
  s.name = 'dotcfg'
  s.summary = 'simple filesystem de/serialization for app configs'
  s.description = 'JSON and YAML config serialization and persistence'
  s.authors = ['Rick Hull']
  s.homepage = 'https://github.com/rickhull/dotcfg'
  s.license = 'MIT'

  s.required_ruby_version = '>= 2'

  s.version  = File.read(File.join(__dir__, 'VERSION')).chomp

  s.files = %w[dotcfg.gemspec VERSION README.md Rakefile]
  s.files += Dir['lib/**/*.rb']
  s.files += Dir['test/**/*.rb']

  s.add_runtime_dependency 'json', '~> 2.5'
  s.add_runtime_dependency 'yaml', '~> 0.1'
end
