require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::ScatterPlot do
  before(:each) { @scatter = GoogleChart::ScatterPlot.new(:encoding => :text) }
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

  it "should have support for point sizes" do
    @scatter.data("Series 1",[[50,50],[100,100]])
    @scatter.point_sizes [15,15]
    @scatter.query_params[:chd].should == "t:50.0,100.0|50.0,100.0|100.0,100.0"
  end

  it "should have raise error if point sizes array is greater than data size" do
    @scatter.data("Series 1",[[50,50],[100,100]])
    lambda { @scatter.point_sizes [15,15,15] }.should raise_error(ArgumentError)
  end


  it "should raise error if point size is not an array" do
    @scatter.data("Series 1",[[50,50],[100,100]])
    lambda { @scatter.point_sizes :gibberish }.should raise_error(ArgumentError)
  end
end
