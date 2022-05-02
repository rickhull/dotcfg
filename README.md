[![CI Status](https://github.com/rickhull/dotcfg/actions/workflows/ci.yaml/badge.svg)](https://github.com/rickhull/dotcfg/actions/workflows/ci.yaml)
[![Gem Version](https://badge.fury.io/rb/dotcfg.svg)](http://badge.fury.io/rb/dotcfg)
[![Code Climate](https://codeclimate.com/github/rickhull/dotcfg/badges/gpa.svg)](https://codeclimate.com/github/rickhull/dotcfg/badges)

dotcfg
======
dotcfg is a simple, intuitive way for your app to store configuration data on the filesystem -- ideally within the user's home directory, presumably in a dotfile.  If your config data can be represented by a Hash, then dotcfg can easily serialize and persist that data between runs.

### Serialization Formats
dotcfg currently understands [JSON](http://json.org) and [YAML](http://yaml.org), defaulting to YAML.

Installation
------------
Install the gem:
```
$ gem install dotcfg
```

Or, if using [Bundler](http://bundler.io/), add to your Gemfile:
```ruby
gem 'dotcfg', '~> 0.1'
```

Usage
-----
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

Details
-------
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
