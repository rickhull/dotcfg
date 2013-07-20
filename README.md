dotcfg
======
dotcfg is a simple, intuitive way for your app to store configuration data on the filesystem -- ideally within the user's home directory, presumably in a dotfile.  If your config data can be represented by a Hash, then dotcfg can easily persist that data on the filesystem.

dotcfg currently understands JSON and YAML, defaulting to JSON.

Usage
-----
```ruby
require 'dotcfg'

# if file exists, read and load it; otherwise initialize the file
CFG = DotCfg.new '~/.example'

CFG[:does_not_exist]
# => nil

CFG['hello'] = 'world'
CFG[:hello]
# => "world"

puts CFG.pretty
# {
#   "hello": "world"
# }

CFG.serialize
# => "{\"hello\":\"world\"}"

CFG.save
# write to ~/.example
```

Use YAML
```ruby
require 'dotcfg'

# if file exists, read and load it; otherwise initialize the file
CFG = DotCfg.new '~/.example', :yaml

# ...

puts CFG.pretty
# ---
# hello: world

CFG.serialize
# => "---\nhello: world\n"

# ...
```

Installation
------------
Install the gem:
```
$ gem install dotcfg # sudo as necessary
```

Or, if using Bundler, add to your Gemfile:
```ruby
gem 'dotcfg', '~> 0.1'
```

Details
-------
The Simplest Thing That Could Possibly Work
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

### Suggestions For Success
Use this in apps, not libraries.  `require 'dotcfg'` should only show up in bin/ files and never those of lib/
