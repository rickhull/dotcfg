require 'buildar'
require 'rake/testtask'

Buildar.new do |b|
  b.use_git = true
  b.version_file = 'VERSION'
end
