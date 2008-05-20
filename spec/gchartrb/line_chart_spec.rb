require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::LineChart do
  before(:each) { @line_chart = GoogleChart::LineChart.new }
  it "should have the correct type" do
    @line_chart.chart_type == "lc"
  end

  it "should initialise the default values" do
    @line_chart.width.should == 320
  end

  it "should raise error when the data is not an array of numeric" do
    lambda { @line_chart.data("Series 1", [[1,2],[2,3]]) }.should raise_error(ArgumentError)
  end

  it "should add a data and a legend" do
    @line_chart.data("Series 1", [1,2,3])
    @line_chart.instance_variable_get("@data").first.should == [1,2,3]
    @line_chart.instance_variable_get("@legends").first.should == "Series 1"
  end

  it "should contain a simple set of query parameters after adding data" do
     @line_chart.title = "Chart"
     @line_chart.data("Series 1", [1,1,1])

     @line_chart.query_params[:cht].should == "lc"
     @line_chart.query_params[:chtt].should == "Chart"
     @line_chart.query_params[:chd].should == "s:999"
     @line_chart.query_params[:chs].should == "320x200"

     @line_chart.data("Series 2", [2,2,2])
     @line_chart.query_params[:chd].should == "s:fff,999"
  end

  it "should render the URL properly when to_url is called" do
    @line_chart.data("Series 1", [1,1,1])
    query_string_to_hash(@line_chart.to_url)[:chd].should == "s:999"
    query_string_to_hash(@line_chart.to_url)[:cht].should == "lc"
  end

  it "should accept extra parameters in the to_url method" do
    @line_chart.data("Series 1", [1,1,1])
    query_string_to_hash(@line_chart.to_url(:chtt => "test"))[:chtt].should == "test"
  end

  it "should replace newline in title to pipe" do
    @line_chart.title="test\nnewline"
    @line_chart.title.should == "test|newline"
  end

  it "should show legend if the show_legend attribute is set to true" do
    @line_chart.data("Series", [1,2,3])
    @line_chart.show_legend = true
    @line_chart.query_params[:chdl].should_not be_nil
  end

  it "should not show legend if show_legend attribute is set to true but legends are nil" do
    @line_chart.data("Test", [1,2,3])
    @line_chart.data(nil, [1,2,3])
    @line_chart.show_legend = true
    @line_chart.query_params[:chdl].should == "Test|"
  end

  it "should have legend support" do
    @line_chart.respond_to?(:legend, true).should be_true
  end

  it "should have color support" do
    @line_chart.respond_to?(:color, true).should be_true
  end

  it "should have the max attribute defined" do
    @line_chart.should respond_to(:max)
    @line_chart.should_not respond_to(:max_x)
    @line_chart.should_not respond_to(:max_y)
  end
end
