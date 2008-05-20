require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::VennDiagram do
  before(:each) { @venn = GoogleChart::VennDiagram.new(:encoding => :text) }
  it "should have the correct type" do
    @venn.chart_type.should == "v"
  end

  it "should have legend,fills and color support" do
    @venn.respond_to?(:legend,true).should be_true
    @venn.should respond_to(:fill)
    @venn.respond_to?(:color,true).should be_true
  end

  it "should accept at most 3 data points with an integer value" do
    @venn.data "Circle 1", 5
    @venn.data "Circle 2", 5
    @venn.data "Circle 3", 5
    lambda { @venn.data "Circle 4", 5 }.should raise_error(ArgumentError)
  end

  it "should raise error if the data point is non numeric" do
    lambda { @venn.data "Circle 1", "gibberish" }.should raise_error(ArgumentError)
  end

  it "should accept a maximum of 4 intersection points" do
    @venn.data "Circle 1", 5
    @venn.data "Circle 2", 5
    @venn.data "Circle 3", 5
    @venn.intersections 2,3,4,5
    lambda { @venn.intersections 2,3,4,5,6 }.should raise_error(ArgumentError)
  end

  it "should raise error if no data is entered and intersections are being added" do
    lambda { @venn.intersections 2,3,4 }.should raise_error(ArgumentError)
  end

  it "should raise error if number of intersections is greater than the number of data points + 1" do
    @venn.data "Circle 1", 5
    @venn.data "Circle 2", 5
    lambda { @venn.intersections 2,3,4,5 }.should raise_error(ArgumentError)
  end

  it "should raise error if the intersection values are not integers" do
    @venn.data "Circle 1", 5
    @venn.data "Circle 2", 5
    lambda { @venn.intersections "hi",3 }.should raise_error(ArgumentError)
  end

  it "should encode values and intersections correctly" do
    @venn.encoding = :text
    @venn.data "Circle 1", 100
    @venn.data "Circle 2", 100
    @venn.intersections 5
    @venn.query_params[:chd].should == "t:100.0,100.0,0.0,5.0"
  end
end
