require 'dotcfg'
require 'benchmark/ips'

def new_filename
  begin
    Dir::Tmpname.make_tmpname('/tmp/dotcfg', nil)
  rescue
    ['/tmp/dotcfg', rand(9**9)].join('-')
  end
end

fn = new_filename
dc = DotCfg.new(fn)
dc['foo'] = 0

Benchmark.ips do |b|
  b.config time: 5, warmup: 0.5
  b.report("write #{fn}") {
    dc['foo'] += 1
    dc.save
  }

  b.report("rewrite #{fn}") {
    dc.load
    dc['foo'] += 1
    dc.save
  }

  b.compare!
end

p dc.to_h

File.unlink fn
