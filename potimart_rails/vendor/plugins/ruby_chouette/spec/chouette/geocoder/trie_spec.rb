require 'spec_helper'
include Chouette::Geocoder

require 'digest/md5'

describe Trie do

  before(:each) do
    @trie = Trie.new
    @key, @value = "key", "value"
    @wrong_value = "wrong value"
  end

  describe "push" do

    it "should retrieve an Array with pushed value" do
      @trie.push @key, @value
      @trie.get(@key).should == [@value]
    end

    it "should concat values for an existing @key" do
      @trie.push @key, "dummy"
      @trie.push @key, @value
      @trie.get(@key).should == ["dummy", @value]
    end
    
  end

  describe "start_with" do

    it "should find values if nodes starting with given prefix" do
      @trie.push @key + "1", @value + "1"
      @trie.push @key + "2", @value + "2"

      @trie.push "a", @wrong_value
      @trie.push "kea", @wrong_value
      @trie.push "kez", @wrong_value
      @trie.push "z", @wrong_value

      @trie.start_with(@key).should == [@value + "1", @value + "2"]
    end
    
  end

  describe "find" do 

    it "should node matching given prefix" do
      @trie.push @key, @value
      @trie.push @key + "1", @value + "1"
      @trie.push @key + "2", @value + "2"
      
      @trie.find(@key).family.collect(&:value).sort.should == [[@value], [@value + "1"], [@value + "2"]]
    end

  end

  describe "to_dot" do

    it "should create a dot description of nodes" do
      @trie.push @key, @value
      @trie.to_dot.should match(/digraph G \{ [-0-9]+ \[label="k \(1\)"\]; [-0-9]+ -> [-0-9]+ \[label=mid\]; [-0-9]+ \[label="e \(1\)"\]; [-0-9]+ -> [-0-9]+ \[label=mid\]; [-0-9]+ \[label="y \(1\)"\]; \}/)
    end

    it "should add values representation with :with_value option" do
      @trie.push "k", "value"
      @trie.to_dot(:with_value => true).should match(/digraph G \{ [-0-9]+ \[label=\"k \(1\)\"\]; [-0-9]+ \[label=\"value\",shape=box\] [-0-9]+ -> [-0-9]+ \[style=dotted\] \}/)
    end
    
  end

  describe "write_dot" do

    before(:each) do
      @trie.stub!(:to_dot).and_return("dot_description")
    end

    def filename(extension)
      Dir.mkdir("tmp") unless File.exist?("tmp")
      @filename = "tmp/write_dot_spec.#{extension}"
    end

    after(:each) do
      File.delete(@filename) if @filename and File.exist?(@filename)
    end
    
    it "should write the dot description into the specified file (if extension is .dot)" do
      @trie.write_dot(filename(:dot))
      File.read(filename(:dot)).should == "dot_description"
    end

    it "should write the dot description into the specified file (if extension is .dot)" do
      pipe = mock("pipe").tap do |pipe|
        pipe.should_receive(:print).with("dot_description")
        pipe.should_receive(:flush)
      end
      IO.should_receive(:popen).with("dot -Tpng -o #{filename(:png)}", "w").and_yield(pipe)
      @trie.write_dot(filename(:png))
    end

  end

  describe "count" do

    it "should return the count of values associated to the given prefix" do
      @trie.push @key + "1", @value + "1"
      @trie.push @key + "2", @value + "2"
      @trie.push @key + "2", @value + "2"
      @trie.push @key + "3", @value + "3"

      @trie.count(@key).should == 4
      @trie.count(@key + "1").should == 1
      @trie.count(@key + "2").should == 2
      @trie.count(@key + "3").should == 1
    end

    it "should be zero when no value is associated to the prefix" do
      @trie.count("dummy").should be_zero
    end

    

  end

end

