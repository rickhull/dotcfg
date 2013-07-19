require 'json'
require 'yaml'

# uses JSON or YAML for serialization
# top-level structure is object/hash/dict
#
class DotCfg
  def self.normalize key
    case key
    when Numeric, Symbol
      # do nothing
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
    @storage = DEFAULT.dup
    reset unless File.exists? @filename
  end

  def [] key
    @storage[self.class.normalize key]
  end

  def []= key, value
    @storage[self.class.normalize key] = value
  end

  def delete key
    @storage.delete(self.class.normalize key)
  end

  def method_missing key, *args
    if key[-1,1] == '='
      self[key[0, key.length - 1]] = args.first
    else
      self[key]
    end
  end

  def respond_to? key, *args
    true
  end

  def serialize
    self.class::PROCS[@format][:to].call @storage
  end

  def deserialize junk
    @storage = self.class::PROCS[@format][:from].call junk
  end

  def dump
    self.class::PROCS[@format][:pretty].call @storage
  end

  def save
    File.open(@filename, 'w') { |f| f.write self.serialize }
  end

  def load
    rescues = 0
    begin
      File.open(@filename, 'r') { |f| @storage = self.deserialize f.read }
    rescue Exception => e
      rescues += 1
      puts  "#{e} (#{e.class})"
      if rescues < 2
        puts "Resetting #{@filename}"
        reset
        retry
      end
      puts "load failed!"
      raise e
    end
  end

  def reset
    @storage = DEFAULT.dup
    save
  end
end
