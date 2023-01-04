[![CI Status](https://github.com/rickhull/dotcfg/actions/workflows/ci.yaml/badge.svg)](https://github.com/rickhull/dotcfg/actions/workflows/ci.yaml)
[![Gem Version](https://badge.fury.io/rb/dotcfg.svg)](http://badge.fury.io/rb/dotcfg)
[![Code Climate](https://codeclimate.com/github/rickhull/dotcfg/badges/gpa.svg)](https://codeclimate.com/github/rickhull/dotcfg/badges)

# dotcfg

dotcfg is a simple, intuitive way for your app to store configuration data on the filesystem -- ideally within the user's home directory, presumably in a dotfile.  If your config data can be represented by a Hash, then dotcfg can easily serialize and persist that data between runs.

## Serialization Formats
dotcfg currently understands [JSON](http://json.org) and [YAML](http://yaml.org), defaulting to YAML.

# Usage

## Install

### `git clone`

Clone the repo, then `cd dotcfg`

Optional, if you use *direnv* and want to use Nix flakes to load a dev env:
`direnv allow`

From here, use `-I lib` with calls to e.g. `ruby` or `irb` to make dotcfg
available without having the gem installed. e.g.

```
$ irb -Ilib -rdotcfg

irb(main):001:0> CFG = DotCfg.new 'example.cfg'
=>
#<DotCfg:0x00007f75d06b83a0
...
irb(main):002:0> CFG[:does_not_exist]
=> nil
irb(main):003:0> CFG['hello'] = 'world'
=> "world"
irb(main):004:0> CFG['hello']
=> "world"
irb(main):005:0>
```

### `gem install`

```
gem install dotcfg
```

### [Bundler](http://bundler.io/)

Add to your Gemfile:

```ruby
gem 'dotcfg', '~> 1.0'
```

## Usage

```ruby
require 'dotcfg'

# if file exists, read and load it; otherwise initialize the file
CFG = DotCfg.new '~/.example'

CFG[:does_not_exist]
# => nil

CFG['hello'] = 'world'
CFG['hello']
# => "world"

puts CFG.pretty
# ---
# hello: world

CFG.serialize
# => "---\nhello: world\n"

CFG.save
# write to ~/.example
```

Use JSON
```ruby
require 'dotcfg'

# if file exists, read and load it; otherwise initialize the file
CFG = DotCfg.new '~/.example', :json

# ...

puts CFG.pretty
# {
#   "hello": "world"
# }

CFG.serialize
# => "{\"hello\":\"world\"}"

# ...
```

## Details

### Symbols and Strings

When JSON consumes symbols, it emits strings. So if you want to use JSON, use strings rather than symbols for your config items.  YAML cycles strings and symbols independently, so stick to one or the other.

### The Simplest Thing That Could Possibly Work
```ruby
PROCS = {
  json: {
    to: proc { |data| data.to_json },
    from: proc { |json| JSON.parse json },
    pretty: proc { |data| JSON.pretty_generate data },
  },
  yaml: {
    to: proc { |data| data.to_yaml },
    from: proc { |yaml| YAML.load yaml },
    pretty: proc { |data| data.to_yaml },
  },
}
```
