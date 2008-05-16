require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::PieChart do
  before(:each) { @pie = GoogleChart::PieChart.new(:encoding => :text) }
  it "should have the correct type by default" do
    @pie.chart_type.should == "p"
  end

  it "should have fills,color and label support" do
    @pie.respond_to?(:label,true).should be_true
    @pie.should respond_to(:fill)
    @pie.respond_to?(:color,true).should be_true
  end

  it "should change type to p3 if the is_3d option is set to true" do
    @pie.is_3d = true
    @pie.chart_type.should == "p3"
    @pie.is_3d?.should be_true
  end

  it "should have show_labels set to true by default" do
    @pie.show_labels?.should be_true
  end

  it "should take in data and render the params correctly" do
    @pie.data "Series 1", 20
    @pie.data "Series 2", 100
    @pie.data "Series 3", 40
    @pie.query_params[:chd].should == "t:20.0,100.0,40.0"
    @pie.query_params[:chl].should == "Series 1|Series 2|Series 3"
  end

  it "should not accept non numeric data" do
    lambda { @pie.data "Series", [1,2,3] }.should raise_error(ArgumentError)
  end
end