Gem::Specification.new do |s|
  s.name = 'dotcfg'
  s.summary = 'simple filesystem de/serialization for app configs'
  s.homepage = 'https://github.com/rickhull/dotcfg'
  s.author = 'Rick Hull'
  s.license = 'MIT'
  s.description = 'JSON and YAML config serialization and persistence'
  s.files = %w{Rakefile lib/dotcfg.rb}
  s.add_runtime_dependency 'json', '~> 1'
  s.add_development_dependency 'buildar', '~> 2'
end
