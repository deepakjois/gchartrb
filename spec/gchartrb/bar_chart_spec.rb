require File.expand_path("#{File.dirname(__FILE__)}/../helper")

module BarChartHelper
  def add_valid_data(chart)
    chart.data "Series 1", [1,2,3,4,5]
  end
end

describe GoogleChart::BarChart do
  include BarChartHelper

  before(:each) { @bar = GoogleChart::BarChart.new }
  it "should have the default type as bvg" do
    @bar.chart_type.should == "bvg"
  end

  it "should raise error when the data is not an array of numeric" do
    lambda { @bar.data("Series 1", [[1,2],[2,3]]) } .should raise_error(ArgumentError)
  end

  it "should have legend support" do
    @bar.respond_to?(:legend, true).should be_true
  end

  it "should support orientation" do
    lambda { @bar.orientation = :horizontal }.should_not raise_error(NoMethodError)
    lambda { @bar.orientation = :vertical }.should_not raise_error(NoMethodError)
    lambda { @bar.orientation = :gibberish }.should raise_error(ArgumentError)
  end

  it "should support grouping" do
    lambda { @bar.grouping = :grouped }.should_not raise_error(NoMethodError)
    lambda { @bar.grouping = :stacked }.should_not raise_error(NoMethodError)
    lambda { @bar.grouping = :gibberish }.should raise_error(ArgumentError)
  end

  it "should change chart type on changes in orientation and grouping" do
    @bar.grouping    = :stacked
    @bar.orientation = :vertical
    @bar.chart_type.should be_eql("bvs")

    @bar.grouping    = :stacked
    @bar.orientation = :horizontal
    @bar.chart_type.should be_eql("bhs")

    @bar.grouping    = :grouped
    @bar.orientation = :vertical
    @bar.chart_type.should be_eql("bvg")

    @bar.grouping    = :grouped
    @bar.orientation = :horizontal
    @bar.chart_type.should be_eql("bhg")
  end

  it "should support bar width in charts" do
    add_valid_data(@bar)
    @bar.bar_width = 5
    @bar.query_params[:chbh].should == "5"
  end

  it "should raise error if bar width is not an integer" do
    add_valid_data(@bar)
    lambda { @bar.bar_width = "hi" }.should raise_error(ArgumentError)
  end

  it "support bar spacing (within a group)" do
    add_valid_data(@bar)
    @bar.bar_width = 5
    @bar.bar_spacing = 5
    @bar.query_params[:chbh].should == "5,5"
  end

  it "should raise error if bar spacing is not an integer" do
    add_valid_data(@bar)
    @bar.bar_width = 5
    lambda { @bar.bar_spacing = "hi" }.should raise_error(ArgumentError)
  end

  it "should not support bar spacing without bar width" do
    add_valid_data(@bar)
    lambda { @bar.bar_spacing = 5 }.should raise_error(ArgumentError)
  end

  it "support group spacing" do
    add_valid_data(@bar)
    @bar.bar_width = 5
    @bar.bar_spacing = 5
    @bar.group_spacing = 5
    @bar.query_params[:chbh].should == "5,5,5"
  end

  it "should raise error if group spacing is not an integer" do
    add_valid_data(@bar)
    @bar.bar_width = 5
    @bar.bar_spacing = 5
    lambda { @bar.group_spacing = "hi" }.should raise_error(ArgumentError)
  end

  it "should not support group spacing without bar width and bar spacing" do
    add_valid_data(@bar)
    lambda { @bar.group_spacing = 5 }.should raise_error(ArgumentError)
    @bar.bar_width = 5
    lambda { @bar.group_spacing = 5 }.should raise_error(ArgumentError)
  end

  it "should encode properly encode the max value for the stacked bar chart" do
    @bar.orientation = :vertical
    @bar.grouping = :stacked
    @bar.encoding = :extended
    @bar.data "2^i", (0..8).to_a.collect{|i| 2**i}, "ff0000"
    @bar.data "2.1^i", (0..8).to_a.collect{|i| 2.1**i}, "00ff00"
    @bar.data "2.2^i", (0..8).to_a.collect{|i| 2.2**i}, "0000ff"
    @bar.query_params[:chd].starts_with?("e:ADAHAOAcA3BvDeG7N2").should be_true
    @bar.max.should == (2**8 + 2.1**8 + 2.2**8)
  end

  it "should use the max value as an override if it is specified already" do
    @bar.orientation = :vertical
    @bar.grouping = :stacked
    @bar.encoding = :extended
    @bar.data "2^i", (0..8).to_a.collect{|i| 2**i}, "ff0000"
    @bar.data "2.1^i", (0..8).to_a.collect{|i| 2.1**i}, "00ff00"
    @bar.data "2.2^i", (0..8).to_a.collect{|i| 2.2**i}, "0000ff"
    @bar.max = (2**8 + 2.1**8 + 2.2**8) * 2
    @bar.query_params[:chd].starts_with?("e:ADAHAOAcA3BvDeG7N2").should be_false
    @bar.max.should_not == (2**8 + 2.1**8 + 2.2**8)
  end
end
