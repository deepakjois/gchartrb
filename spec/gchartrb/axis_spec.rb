require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::Axis do
  before(:each) do
    @chart = GoogleChart::LineChart.new
    @chart.data "Series 1", [1,2,3,4,5], "ff00ff"
    @valid_axis_params = {
                          :color => "ff00ff" ,
                          :font_size => 15,
                          :alignment => :center,
                          :range     => 0..500,
                          :labels    => ["a","b","c"],
                          :positions => [100,200,400]
                          }
  end

  it "is supported by LineChart, LineXYChart, BarChart, ScatterPlot and SparklineChart" do
    [GoogleChart::LineChart, GoogleChart::LineXYChart,
    GoogleChart::BarChart, GoogleChart::ScatterPlot, GoogleChart::SparklineChart].each do |klass|
      klass.new.should respond_to(:axis)
    end
  end

  it "throws ArgumentError if the the fill method is called with an invalid position type" do
    lambda { @chart.axis(:gibberish) }.should raise_error(ArgumentError)
  end

  it "should be able to initialise the properties from within a block" do
    @chart.axis(:top) do |axis|
      axis.color     = "ff00ff"
      axis.font_size = 15
      axis.alignment = :center
      axis.range     = 0..500
      axis.labels    = ["a","b","c"]
      axis.positions = [100,200,400]
    end
    @chart.query_params[:chxt].should eql("t")
    @chart.query_params[:chxs].should eql("0,ff00ff,15,0")
    @chart.query_params[:chxl].should eql("0:|a|b|c")
    @chart.query_params[:chxp].should eql("0,100,200,400")
    @chart.query_params[:chxr].should eql("0,0,500")
  end

  it "should raise error if color is not a string (unless it is nil)" do
    params = @valid_axis_params.except(:color, :font_size, :alignment)
    lambda { @chart.axis(:top, params) }.should_not raise_error(ArgumentError)

    params[:color] = 35
    lambda { @chart.axis(:top, params) }.should raise_error(ArgumentError)
  end

  it "should raise error if font_size is not a number (unless it is nil)" do
    params = @valid_axis_params.except(:font_size, :alignment)
    lambda { @chart.axis(:top, params) }.should_not raise_error(ArgumentError)

    params[:font_size] = "hi"
    lambda { @chart.axis(:top, params) }.should raise_error(ArgumentError)
  end

  it "should raise error if range does not belong to class range and is not numeric (unless it is nil)" do
    params = @valid_axis_params.except(:range)
    lambda { @chart.axis(:top, params) }.should_not raise_error(ArgumentError)

    params[:range] = "hi"
    lambda { @chart.axis(:top, params) }.should raise_error(ArgumentError)
  end

  it "should raise error if labels is not an array (and is not nil)" do
    params = @valid_axis_params.except(:labels, :positions)
    lambda { @chart.axis(:top, params) }.should_not raise_error(ArgumentError)

    params[:labels] = "hi"
    lambda { @chart.axis(:top, params) }.should raise_error(ArgumentError)
  end

  it "should raise error if positions is not numeric array" do
    params = @valid_axis_params.except(:positions)
    lambda { @chart.axis(:top, params) }.should_not raise_error(ArgumentError)

    params[:positions] =  %w(a b c)
    lambda { @chart.axis(:top, params) }.should raise_error(ArgumentError)

    params[:positions] = "hi"
    lambda { @chart.axis(:top, params) }.should raise_error(ArgumentError)
  end

  it "should raise error if the number of elements for labels and positions are not the same (unless they are nil)" do
    params = @valid_axis_params.except(:labels)
    params[:labels] =  %w(a b c d)
    lambda { @chart.axis(:top, params) }.should raise_error(ArgumentError)

    params[:labels] = nil
    lambda { @chart.axis(:top, params) }.should_not raise_error(ArgumentError)

    params = @valid_axis_params.except(:labels, :positions)
    lambda { @chart.axis(:top, params) }.should_not raise_error(ArgumentError)
  end

  it "should raise error if font_size is given without color" do
    params = @valid_axis_params.except(:color, :alignment)
    lambda { @chart.axis(:top, params) }.should raise_error(ArgumentError)
  end

  it "should raise error if alignment is given without a font size and color" do
    params = @valid_axis_params.except(:color, :font_size)
    lambda { @chart.axis(:top, params) }.should raise_error(ArgumentError)
  end

  it "should raise error if an invalid alignment is given (unless it is nil)" do
    params = @valid_axis_params.except(:alignment)
    lambda { @chart.axis(:top, params) }.should_not raise_error(ArgumentError)

    params[:alignment] = :gibberish
    lambda { @chart.axis(:top, params) }.should raise_error(ArgumentError)
  end

  it "should raise an error if both position and range are given and the positions are not in range" do
    params = @valid_axis_params.except(:positions, :range)
    params[:positions] = [0,1,2]
    lambda { @chart.axis(:top, params) }.should_not raise_error(ArgumentError)
    params[:range] = 100..200
    lambda { @chart.axis(:top, params) }.should raise_error(ArgumentError)
  end

end
