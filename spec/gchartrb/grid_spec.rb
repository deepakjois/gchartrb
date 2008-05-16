require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::Grid do
  before(:each) do
    @chart = GoogleChart::LineChart.new
    @chart.data "Series 1", [1,2,3,4,5], "ff00ff"
    @valid_grid_params = { :x_step => 20, :y_step => 50, :line_segment => 1, :blank_segment => 5 }
  end

  it "is supported by LineChart, LineXYChart, BarChart, ScatterPlot and SparklineChart" do
    [GoogleChart::LineChart, GoogleChart::LineXYChart,
    GoogleChart::BarChart, GoogleChart::ScatterPlot, GoogleChart::SparklineChart].each do |klass|
      klass.new.should respond_to(:grid)
    end
  end

  it "should be able to take in values via a hash and generate a correct URL" do
    @chart.grid(@valid_grid_params)
    @chart.query_params[:chg].should == "20,50,1,5"
  end

  it "should be able to take in values via a block and generate a correct URL" do
    @chart.grid do |g|
      g.x_step        = 20
      g.y_step        = 50
      g.line_segment  = 1
      g.blank_segment = 5
    end
    @chart.query_params[:chg].should == "20,50,1,5"
  end

  it "should raise an error if any of the values is non numeric" do
    params = @valid_grid_params.except(:x_step)
    params[:x_step] = "yo"
    lambda { @chart.grid(params) }.should raise_error(ArgumentError)

    params = @valid_grid_params.except(:y_step)
    params[:y_step] = "yo"
    lambda { @chart.grid(params) }.should raise_error(ArgumentError)

    params = @valid_grid_params.except(:line_segment)
    params[:line_segment] = "yo"
    lambda { @chart.grid(params) }.should raise_error(ArgumentError)

    params = @valid_grid_params.except(:blank_segment)
    params[:blank_segment] = "yo"
    lambda { @chart.grid(params) }.should raise_error(ArgumentError)
  end

  it "should throw an error if x_step or y_step are not within 0 to 100" do
    params = @valid_grid_params.except(:x_step)
    params[:x_step] = 200
    lambda { @chart.grid(params) }.should raise_error(ArgumentError)

    params = @valid_grid_params.except(:y_step)
    params[:y_step] = 200
    lambda { @chart.grid(params) }.should raise_error(ArgumentError)
  end
end
