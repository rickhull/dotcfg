require 'json'
require 'yaml'

# uses JSON or YAML for serialization
# top-level structure is object/hash/dict
#
# e.g.
# d = DotCfg.new('~/.dotcfg')
# d['hello'] = 'world'
# d['hello']
# => "world"
# d.save
# d['get'] = "bent"
# d.load
# d['get']
# => nil
#
class DotCfg
  def self.normalize key
    case key
    when Numeric, Symbol
      key                # pass thru
    when String
      # leading numerics are invalid
      raise "invalid key: #{key}" if key[0,1] == '0' or key[0,1].to_i != 0
      key.downcase.gsub(/\W/, '_').to_sym
    else
      raise "invalid key: #{key} (#{key.class})"
    end
  end

  DEFAULT = {}

  PROCS = {
    json: {
      to: proc { |data| data.to_json },
      from: proc { |json| YAML.load json },
      pretty: proc { |data| JSON.pretty_generate data },
    },
    yaml: {
      to: proc { |data| data.to_yaml },
      from: proc { |yaml| YAML.load yaml },
      pretty: proc { |data| data.to_yaml },
    },
  }

  attr_reader :filename, :format, :storage

  def initialize filename, format = :json
    @filename = File.expand_path filename
    @format = format
    @storage = {}
    File.exists?(@filename) ? self.try_load : self.reset
  end

  #
  # @storage manipulation
  #

  def [] key
    key = self.class.normalize key
    @storage[key] or @storage[key.to_s]
  end

  def []= key, value
    @storage[self.class.normalize(key)] = value
  end

  def delete key
    @storage.delete(self.class.normalize(key))
  end

  #
  # serialization, using PROCS
  #

  def serialize
    raise "invalid storage" unless @storage.is_a? Hash
    self.class::PROCS.fetch(@format)[:to].call @storage
  end

  def deserialize junk
    data = self.class::PROCS.fetch(@format)[:from].call junk
    raise "invalid junk: #{junk} (#{junk.class})" unless data.is_a? Hash
    data.each { |k, v| self[k] = v }
    @storage
  end

  def dump
    self.class::PROCS.fetch(@format)[:pretty].call @storage
  end

  #
  # file operations
  #

  def save
    File.open(@filename, 'w') { |f| f.write self.serialize }
  end

  def load
    File.open(@filename, 'r') { |f| self.deserialize f.read }
  end

  def try_load
    rescues = 0
    begin
      self.load
    rescue SystemCallError => e
      rescues += 1
      puts  "#{e} (#{e.class})"
      if rescues < 2
        puts "Resetting #{@filename}"
        reset
        retry
      end
      puts "try_load failed!"
      raise e
    end
  end

  def reset
    @storage = DEFAULT.dup
    save
  end
end
