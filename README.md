dotcfg
======
dotcfg is a simple, intuitive way for your app to store configuration data on the filesystem -- ideally within the user's home directory, presumably in a dotfile.  If your config data can be represented by a Hash, then dotcfg can easily persist that data on the filesystem.

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
