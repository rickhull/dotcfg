require 'minitest/autorun'
require 'dotcfg'

describe DotCfg do
  def new_filename
    begin
      Dir::Tmpname.make_tmpname('/tmp/dotcfg', nil)
    rescue
      ['/tmp/dotcfg', rand(9**9)].join
    end
  end

  before do
    @filename = new_filename
    @dc = DotCfg.new(@filename)
  end

  describe "bad initialization" do
    it "raises" do
      expect { DotCfg.new('does/not/exist') }.must_raise Errno::ENOENT
    end
    it "creates a new file" do
      expect(File.exist?(@filename)).must_equal true
    end
  end

  describe "config manipulation" do
    describe "accessing keys" do
      before do
        @dc['hello'] = 'world'
      end

      describe "nonexistent keys" do
        it "returns nil" do
          expect(@dc[:does_not_exist]).must_be_nil
        end
      end

      describe "existing keys" do
        it "returns the value" do
          expect(@dc['hello']).must_equal 'world'
        end
      end

      describe "key removal" do
        it "returns nil" do
          @dc[:hello] = :world
          expect(@dc[:hello]).must_equal :world
          @dc.delete :hello
          expect(@dc[:hello]).must_be_nil
        end
      end

      after do
        @dc.delete 'hello'
      end
    end
  end

  describe "serialization" do
    before do
      @dc['hello'] = 'world'
      @dc['goodbye'] = 'cruel world'
    end

    it "serializes to a string" do
      expect(@dc.serialize).must_be_kind_of String
    end

    it "deserializes its serialization" do
      hsh = @dc.deserialize(@dc.serialize)
      expect(hsh).must_be_kind_of Hash
      expect(hsh).must_equal({ 'hello' => 'world', 'goodbye' => 'cruel world' })
      expect(@dc['hello']).must_equal 'world'
      expect(@dc['goodbye']).must_equal 'cruel world'
    end

    it "overwrites when deserializing" do
      str = @dc.serialize
      @dc.delete 'hello'
      @dc.deserialize(str)
      expect(@dc['hello']).must_equal 'world'
    end

    it "responds to pretty with a string" do
      expect(@dc.pretty).must_be_kind_of String
    end

    # eh, needed?
    after do
      @dc.delete 'hello'
      @dc.delete 'goodbye'
    end
  end

  after do
    File.unlink(@filename)
  end
end
