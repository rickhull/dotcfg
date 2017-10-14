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

  describe "new" do
    describe "bad file path" do
      it "must raise" do
        proc { DotCfg.new('does/not/exist') }.must_raise Errno::ENOENT
      end
    end

    describe "nonexistent valid file path" do
      it "must create a new file" do
        File.exist?(@filename).must_equal true
      end
    end
  end

  describe "config manipulation" do
    describe "accessing keys" do
      before do
        @dc['hello'] = 'world'
      end

      describe "nonexistent keys" do
        it "must return nil" do
          @dc[:does_not_exist].must_be_nil
        end
      end

      describe "existing keys" do
        it "must return the value" do
          @dc['hello'].must_equal 'world'
        end
      end

      describe "key removal" do
        it "must return nil" do
          @dc[:hello] = :world
          @dc[:hello].must_equal :world
          @dc.delete :hello
          @dc[:hello].must_be_nil
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

    it "must serialize to a string" do
      @dc.serialize.must_be_kind_of String
    end

    it "must deserialize its serialization" do
      hsh = @dc.deserialize(@dc.serialize)
      hsh.must_be_kind_of Hash
      hsh.must_equal({ 'hello' => 'world', 'goodbye' => 'cruel world' })
      @dc['hello'].must_equal 'world'
      @dc['goodbye'].must_equal 'cruel world'
    end

    it "must overwrite when deserializing" do
      str = @dc.serialize
      @dc.delete 'hello'
      @dc.deserialize(str)
      @dc['hello'].must_equal 'world'
    end

    it "must pretty-serialize to a string" do
      @dc.pretty.must_be_kind_of String
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
