Gem::Specification.new do |s|
  s.name = 'dotcfg'
  s.summary = 'simple filesystem de/serialization for app configs'
  s.author = 'Rick Hull'
  s.homepage = 'https://github.com/rickhull/dotcfg'
  s.license = 'MIT'
  s.description = 'JSON and YAML config serialization and persistence'

  s.required_ruby_version = '~> 3.0'
  s.add_runtime_dependency 'json', '~> 2.5'
  s.add_runtime_dependency 'yaml', '~> 0.1'
  s.add_development_dependency 'buildar', '~> 2'

  s.version  = File.read(File.join(__dir__, 'VERSION')).chomp

  s.files = %w[
    dotcfg.gemspec
    VERSION
    README.md
    Rakefile
    lib/dotcfg.rb
    test/dotcfg.rb
  ]
end
