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
      key.downcase.gsub(/[\W_]+/, '_').gsub(/_\z/, '').to_sym
    else
      raise "invalid key: #{key} (#{key.class})"
    end
  end

  PROCS = {
    json: {
      to: proc { |data| data.to_json },
      from: proc { |json| JSON.parse json }, # YAML.load json },
      pretty: proc { |data| JSON.pretty_generate data },
    },
    yaml: {
      to: proc { |data| data.to_yaml },
      from: proc { |yaml| YAML.load yaml },
      pretty: proc { |data| data.to_yaml },
    },
  }

  attr_reader :filename, :format

  def initialize filename, format = :json
    @filename = File.expand_path filename
    @format = format
    @cfg = Hash.new
    File.exists?(@filename) ? self.try_load : self.reset
  end

  #
  # @cfg manipulation
  #

  def [] key
    key = self.class.normalize key
    @cfg[key] or @cfg[key.to_s]
  end

  def []= key, value
    @cfg[self.class.normalize key] = value
  end

  def delete key
    @cfg.delete self.class.normalize key
  end

  # if you need to call this, you might be Doing It Wrong (tm)
  def to_h
    @cfg
  end

  #
  # serialization, using PROCS
  #

  def serialize
    raise "invalid storage" unless @cfg.is_a? Hash
    self.class::PROCS.fetch(@format)[:to].call @cfg
  end

  def deserialize junk
    data = self.class::PROCS.fetch(@format)[:from].call junk
    unless data.is_a? Hash
      raise ArgumentError, "invalid junk: #{junk} (#{junk.class})"
    end
    data.each { |k, v| self[k] = v }
    @cfg
  end

  def pretty
    self.class::PROCS.fetch(@format)[:pretty].call @cfg
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
    rescue SystemCallError, ArgumentError, JSON::ParserError => e
      rescues += 1
      puts  "#{e} (#{e.class})"
      if rescues < 2
        puts "Resetting #{@filename}"
        self.reset
        retry
      end
      puts "try_load failed!"
      raise e
    end
  end

  def reset
    @cfg = Hash.new
    self.save
  end
end
