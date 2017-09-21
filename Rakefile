begin
  require 'buildar'

  Buildar.new do |b|
    b.gemspec_file = 'dotcfg.gemspec'
    b.version_file = 'VERSION'
    b.use_git = true
  end
rescue LoadError
  # ok
end

begin
  require 'rake/testtask'

  Rake::TestTask.new do |t|
    t.test_files = FileList['test/**/*.rb']
  end
  desc "Run tests"
rescue Exception => e
  warn "rake/testtask error: #{e}"
end
