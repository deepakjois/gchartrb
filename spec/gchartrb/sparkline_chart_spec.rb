require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::SparklineChart do
  before(:each) { @sparkline = GoogleChart::SparklineChart.new }
  it "should have the correct type" do
    @sparkline.chart_type == "ls"
  end

  it "should raise error when the data is not an array of numeric" do
    lambda { @sparkline.data("Series 1", [[1,2],[2,3]]) } .should raise_error(ArgumentError)
  end

  it "should have legend support" do
    @sparkline.respond_to?(:legend, true).should be_true
  end
end
