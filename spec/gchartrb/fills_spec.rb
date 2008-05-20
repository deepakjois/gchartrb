require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::Fills do
  before(:each) do
    @chart = GoogleChart::LineChart.new
    @chart.data "Series 1", [1,2,3,4,5], "ff00ff"
  end

  it "is supported by LineChart, LineXYChart, BarChart, ScatterPlot and SparklineChart" do
    [GoogleChart::LineChart, GoogleChart::LineXYChart,
    GoogleChart::BarChart, GoogleChart::ScatterPlot, GoogleChart::SparklineChart].each do |klass|
      klass.new.should respond_to(:fill)
    end
  end

  it "throws ArgumentError if the the fill method is called with an invalid fill type" do
    lambda { @chart.fill(:gibberish) }.should raise_error(ArgumentError)
  end

  it "should throw an ArgumentError on accessing some property which does not exist" do
    lambda { @chart.fill(:solid, :gibberish => "Yo") }.should raise_error(NoMethodError)
    lambda do
      @chart.fill :solid do |f|
        f.gibberish = "Yo"
      end
    end.should raise_error(NoMethodError)
  end

  describe "Solid Fill" do
    it "should be able to initialise the properties from within a block" do
      @chart.fill :solid do |f|
        f.type  = :background
        f.color = "00ff00"
      end
      @chart.query_params[:chf].should be_eql("bg,s,00ff00")
    end

    it "should be able to initialise the properties via a hash" do
      @chart.fill(:solid, :type => :background, :color => "00ff00")
      @chart.query_params[:chf].should be_eql("bg,s,00ff00")
    end

    it "raises error on invalid type" do
      lambda { @chart.fill(:solid, :type => :gibberish, :color => "00ff00") }.should raise_error(ArgumentError)
    end

    it "raises error on invalid colors" do
      lambda { @chart.fill(:solid, :type => :background) }.should raise_error(ArgumentError)
    end

    it "should raise ArgumentError if a non-background fill is not supported"

  end

  describe "Gradient Fill" do

    before(:each) { @valid_gradient_values = {:type => :background, :angle => 45, :colors => ["ff00ff", "00ffff"], :offsets => [0,0.75]} }
    it "should be able to initialise the properties from within a block" do
      @chart.fill :gradient do |f|
        f.type    = :background
        f.angle   = 45
        f.colors  = ["ff00ff", "00ffff"]
        f.offsets = [0,0.75]
      end
      @chart.query_params[:chf].should be_eql("bg,lg,45,ff00ff,0,00ffff,0.75")
    end

    it "should be able to initialise the properties via a hash" do
      @chart.fill(:gradient, @valid_gradient_values)
      @chart.query_params[:chf].should be_eql("bg,lg,45,ff00ff,0,00ffff,0.75")
    end

    it "should raise an error for invalid value of angle" do
      lambda { @chart.fill(:gradient, @valid_gradient_values.merge(:angle => "gibberish")) }.should raise_error(ArgumentError)
    end

    it "raises an error on invalid value for type" do
      lambda { @chart.fill(:gradient, @valid_gradient_values.merge(:type => :gibberish)) }.should raise_error(ArgumentError)
    end

    it "raises an error on invalid value for colors" do
      lambda { @chart.fill(:gradient, @valid_gradient_values.merge(:colors => [nil, 23, "ff00ff"])) }.should raise_error(ArgumentError)
    end

    it "raises an error on invalid value for offests" do
      lambda { @chart.fill(:gradient, @valid_gradient_values.merge(:offsets => [nil, 23, "ff00ff"])) }.should raise_error(ArgumentError)
    end
  end

  describe "Stripes" do
    before(:each) { @valid_stripe_values = {:type => :background, :angle => 45, :colors => ["ff00ff", "00ffff"], :widths => [0.25,0.75]} }

    it "should be able to initialise the properties from within a block" do
      @chart.fill :stripes do |f|
        f.type   = :background
        f.angle  = 45
        f.colors = ["ff00ff", "00ffff"]
        f.widths = [0.25,0.75]
      end
      @chart.query_params[:chf].should be_eql("bg,ls,45,ff00ff,0.25,00ffff,0.75")
    end

    it "should be able to initialise the properties via a hash" do
      @chart.fill(:stripes, @valid_stripe_values)
      @chart.query_params[:chf].should be_eql("bg,ls,45,ff00ff,0.25,00ffff,0.75")
    end

    it "should raise an error on invalid value for type" do
      lambda { @chart.fill(:stripes, @valid_stripe_values.merge(:type => :gibberish)) }.should raise_error(ArgumentError)
    end

    it "should raise an error on invalid value for angle" do
      lambda { @chart.fill(:stripes, @valid_stripe_values.merge(:angle => "gibberish")) }.should raise_error(ArgumentError)
    end

    it "raise an error on invalid value for colors" do
      lambda { @chart.fill(:stripes, @valid_stripe_values.merge(:colors => [:gibberish])) }.should raise_error(ArgumentError)
    end

    it "raise an error on invalid value for widths" do
      lambda { @chart.fill(:stripes, @valid_stripe_values.merge(:widths => ["hi", "there"])) }.should raise_error(ArgumentError)
    end
  end
end
