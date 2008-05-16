require File.expand_path("#{File.dirname(__FILE__)}/../helper")

module RadarChartHelper
  def add_valid_data(chart)
    chart.data "Series 1", [1,2,3,4,5]
  end
end

describe GoogleChart::RadarChart do
  include RadarChartHelper

  before(:each) { @radar = GoogleChart::RadarChart.new }

  it "should have legend,axis,grid,fill and marker support" do
    @radar.respond_to?(:legend, true).should be_true
    @radar.respond_to?(:axis).should be_true
    @radar.respond_to?(:grid).should be_true
    @radar.respond_to?(:fill).should be_true
    @radar.respond_to?(:range_marker).should be_true
  end

  it "should have the default type as r" do
    @radar.chart_type.should == "r"
  end

  it "should change types when the value of splines is set to true" do
    @radar.splines = true
    @radar.chart_type.should == "rs"
  end

  it "should raise error if the splines value is not true or false" do
    lambda { @radar.splines = "hi" }.should raise_error(ArgumentError)
  end

  it "should raise error when the data is not an array of numeric" do
    lambda { @radar.data("Series 1", [[1,2],[2,3]]) } .should raise_error(ArgumentError)
  end


end
