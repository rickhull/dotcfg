require 'rake/testtask'

Rake::TestTask.new :test do |t|
  t.pattern = 'test/*.rb'
  t.warning = true
end

Rake::TestTask.new bench: :test do |t|
  t.pattern = 'test/bench/*.rb'
  t.warning = true
end

task default: :test

begin
  require 'buildar'

  Buildar.new do |b|
    b.gemspec_file = 'dotcfg.gemspec'
    b.version_file = 'VERSION'
    b.use_git = true
  end
rescue LoadError
  warn "buildar tasks unavailable"
end
