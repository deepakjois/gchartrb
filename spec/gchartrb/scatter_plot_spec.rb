require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::ScatterPlot do
  before(:each) { @scatter = GoogleChart::ScatterPlot.new }
  it "should have the correct type" do
    @scatter.chart_type == "s"
  end

  it "should not accept a one dimensional array as input" do
    lambda { @scatter.data("Series 1",[1,2,3,4,5]) }.should raise_error(ArgumentError)
    lambda { @scatter.data("Series 1",[1,[2,3],3,4,5]) }.should raise_error(ArgumentError)
    lambda { @scatter.data("Series 1",[[1,2],[2,"a"]]) }.should raise_error(ArgumentError)
    lambda { @scatter.data("Series 1",[[1,2],[2,3]]) }.should_not raise_error(ArgumentError)
  end


  it "should have legend support" do
    @scatter.respond_to?(:legend, true).should be_true
  end
end
