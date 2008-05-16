require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::LineXYChart do
  before(:each) { @linexy_chart = GoogleChart::LineXYChart.new }
  it "should have the correct type" do
    @linexy_chart.chart_type == "lxy"
  end

  it "should not accept a one dimensional array as input" do
    lambda { @linexy_chart.data("Series 1",[1,2,3,4,5]) }.should raise_error(ArgumentError)
    lambda { @linexy_chart.data("Series 1",[1,[2,3],3,4,5]) }.should raise_error(ArgumentError)
    lambda { @linexy_chart.data("Series 1",[[1,2],[2,"a"]]) }.should raise_error(ArgumentError)
    lambda { @linexy_chart.data("Series 1",[[1,2],[2,3]]) }.should_not raise_error(ArgumentError)
  end

  it "should have legend support" do
    @linexy_chart.respond_to?(:legend, true).should be_true
  end

  it "should process X and Y values correctly" do
    @linexy_chart.data("Series 1",[[1,1],[2,2]])
    @linexy_chart.query_params[:chd].should == "s:f9,f9"
  end

  it "should have a max_x and a max_y value defined" do
    @linexy_chart.should respond_to(:max_x)
    @linexy_chart.should respond_to(:max_y)
    @linexy_chart.should_not respond_to(:max)
  end

end
