require File.expand_path("#{File.dirname(__FILE__)}/helper")

describe GoogleChart::Base do
  before(:each) do
    # Evil metaprogramming. Not sure if I am doing the right thing ;)
    self.instance_eval <<-EOF
    class GoogleChart::Dummy < GoogleChart::Base
      class <<self ; public :new ; end
    end
    EOF
  end

  it "cannot be initialised directly" do
    lambda { GoogleChart::Base.new }.should raise_error(NoMethodError)
  end

  describe GoogleChart::Base, "new instance" do
    before(:each) { @dummy = GoogleChart::Dummy.new }

    it "show have valid height and width values when it is initialised" do
      dummy = GoogleChart::Dummy.new(:height => 200, :width => 400)
      dummy.width.should == 400
      dummy.height.should == 200
    end

    it "should have a default size of 320x200" do
      @dummy.width.should == 320
      @dummy.height.should == 200
    end

    it "should able to initialise size via a WIDTHxHEIGHT string" do
      @dummy.size.should == "320x200"
      @dummy.size = "400x500"
      @dummy.width.should == 400
      @dummy.height.should == 500
    end

    it "should raise an error if the height or width is greater than 1000" do
      lambda { @dummy.height = 1001  }.should raise_error(ArgumentError)
      lambda { @dummy.width = 1001  }.should raise_error(ArgumentError)
    end

    it "should raise error if width x height is greater than 300000" do
      lambda { @dummy.size = "400x1000" }.should raise_error(ArgumentError)
    end

    it "should have a default encoding of :simple" do
      @dummy.encoding.should == :simple
    end

    it "should have attributes for title, title font size and title color" do
      %w(title title_color title_font_size encoding).each { |m| @dummy.respond_to?(:title).should be(true) }
    end

    it "should throw an error on specifying an illegal encoding" do
      lambda { @dummy.encoding = :gibberish }.should raise_error(ArgumentError)
      lambda { @dummy.encoding = :extended }.should_not raise_error(ArgumentError)
    end

    it "should raise an exception when trying to specify type directly" do
      lambda { @dummy.type = :line_xy }.should raise_error(NoMethodError)
    end
  end
end

# Blatantly copied from GChart(http://gchart.rubyforge.org)
describe GoogleChart, ".encode" do
  it "supports the simple, text, and extended encoding" do
    lambda { GoogleChart.encode(:simple, 4, 10) }.should_not raise_error(ArgumentError)
    lambda { GoogleChart.encode(:text, 4, 10) }.should_not raise_error(ArgumentError)
    lambda { GoogleChart.encode(:extended, 4, 10) }.should_not raise_error(ArgumentError)
    lambda { GoogleChart.encode(:monkey, 4, 10) }.should raise_error(ArgumentError)
  end

  it "implements the simple encoding" do
    expected = {
      0 => "A", 19 => "T", 27 => "b", 53 => "1", 61 => "9",
      12 => "M", 39 => "n", 57 => "5", 45 => "t", 51 => "z"
    }

    expected.each do |original, encoded|
      GoogleChart.encode(:simple, original, 61).should == encoded
    end
  end

  it "implements the text encoding" do
    expected = {
      0 => "0.0", 10 => "10.0", 58 => "58.0", 95 => "95.0", 30 => "30.0", 8 => "8.0", 63 => "63.0", 100 => "100.0"
    }

    expected.each do |original, encoded|
      GoogleChart.encode(:text, original, 100).should == encoded
    end
  end

  it "implements the extended encoding" do
    expected = {
      0 => "AA", 25 => "AZ", 26 => "Aa", 51 => "Az", 52 => "A0", 61 => "A9", 62 => "A-", 63 => "A.",
      64 => "BA", 89 => "BZ", 90 => "Ba", 115 => "Bz", 116 => "B0", 125 => "B9", 126 => "B-", 127 => "B.",
      4032 => ".A", 4057 => ".Z", 4058 => ".a", 4083 => ".z", 4084 => ".0", 4093 => ".9", 4094 => ".-", 4095 => ".."
    }

    expected.each do |original, encoded|
      GoogleChart.encode(:extended, original, 4095).should == encoded
    end
  end

  it "encodes nil correctly" do
    GoogleChart.encode(:simple, nil, 1).should == "_"
    GoogleChart.encode(:text, nil, 1).should == "-1"
    GoogleChart.encode(:extended, nil, 1).should == "__"
  end

  it "encodes 0 with a max of 0 correctly using extended" do
    GoogleChart.encode(:extended, 0, 0).should == "AA"
  end

  it "encodes 0 with a max of 0 correctly using simple" do
    GoogleChart.encode(:simple, 0, 0).should == "A"
  end

  it "encodes 0 with a max of 0 correctly using text" do
    GoogleChart.encode(:text, 0, 0).should == "0.0"
  end
end
