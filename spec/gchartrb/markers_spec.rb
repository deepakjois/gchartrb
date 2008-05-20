require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GoogleChart::Markers do
  before(:each) do
    @chart = GoogleChart::LineChart.new
    @chart.data "Series 1", [1,2,3,4,5], "ff00ff"
  end

 it "is supported by LineChart, LineXYChart, BarChart, ScatterPlot and SparklineChart" do
    [GoogleChart::LineChart, GoogleChart::LineXYChart,
    GoogleChart::BarChart, GoogleChart::ScatterPlot, GoogleChart::SparklineChart].each do |klass|
      klass.new.should respond_to(:shape_marker)
      klass.new.should respond_to(:range_marker)
    end
  end

  describe ".shape_marker" do
    before(:each) { @valid_shape_marker = { :color => "ff00ff", :data_set => 0, :data_point => 1, :size => 4, :priority => :low } }

    it "should be able to initialise the marker with an orientation and options hash" do
      @chart.shape_marker(:arrow, @valid_shape_marker)
      @chart.query_params[:chm].should == "a,ff00ff,0,1,4,-1"
    end

    it "should be able to initialise the marker with an orientation and block passed in" do
      @chart.shape_marker(:arrow) do |marker|
        marker.color = "ff00ff"
        marker.data_set = 0
        marker.data_point = 1
        marker.size = 4
        marker.priority = :low
      end
      @chart.query_params[:chm].should == "a,ff00ff,0,1,4,-1"
    end

    it "should raise an error if the shape is invalid" do
      lambda { @chart.shape_marker(:gibberish,@valid_shape_marker) }.should raise_error(ArgumentError)
    end

    it "should raise error if color is not a string" do
      params = @valid_shape_marker.except(:color)
      params[:color] = :hi
      lambda { @chart.shape_marker(:arrow,params) }.should raise_error(ArgumentError)
    end

    it "should raise error if data set is not an integer and is greater than the available number of data sets" do
      params = @valid_shape_marker.except(:data_set)
      params[:data_set] = 1
      lambda { @chart.shape_marker(:arrow,params) }.should raise_error(ArgumentError)

      params[:data_set] = -1
      lambda { @chart.shape_marker(:arrow,params) }.should raise_error(ArgumentError)

      params[:data_set] = "hi"
      lambda { @chart.shape_marker(:arrow,params) }.should raise_error(ArgumentError)
    end

    it "should raise error if data point is not an integer and is greater than the available number of data points for the data set" do
      params = @valid_shape_marker.except(:data_point)
      params[:data_point] = 5
      lambda { @chart.shape_marker(:arrow,params) }.should raise_error(ArgumentError)

      params[:data_point] = -1
      lambda { @chart.shape_marker(:arrow,params) }.should raise_error(ArgumentError)

      params[:data_point] = "hi"
      lambda { @chart.shape_marker(:arrow,params) }.should raise_error(ArgumentError)
    end

    it "should  raise error if the priority is not :low or :high" do
      params = @valid_shape_marker.except(:priority)
      params[:priority] = 5
      lambda { @chart.shape_marker(:arrow,params) }.should raise_error(ArgumentError)
    end

    it "should not raise error if the priority is nil" do
      params = @valid_shape_marker.except(:priority)
      params[:priority] = nil
      lambda { @chart.shape_marker(:arrow,params) }.should_not raise_error(ArgumentError)
    end

    it "should raise error if size is not an integer" do
      params = @valid_shape_marker.except(:size)
      params[:size] = "hi"
      lambda { @chart.shape_marker(:arrow,params) }.should raise_error(ArgumentError)
    end

    it "should accept a text option for a text marker" do
      @chart.shape_marker(:text, @valid_shape_marker.merge(:text => "Hi There"))
    end

    it "should not accept a text option for a text marker" do
      lambda { @chart.shape_marker(:arrow, @valid_shape_marker.merge(:text => "Hi There")) }.should raise_error(ArgumentError)
    end

    it "should format the text marker correctly" do
      @chart.shape_marker(:text, @valid_shape_marker.merge(:text => "Hi There"))
      @chart.query_params[:chm].should == "tHi+There,ff00ff,0,1,4,-1"
    end

  end

  describe ".range_marker" do

    before(:each) { @valid_range_marker = {:color => "ff00ff", :start => 0.5, :end => 0.7} }

    it "should be able to initialise the marker with an orientation and options hash" do
      @chart.range_marker(:vertical,@valid_range_marker)
      @chart.query_params[:chm].should == "R,ff00ff,0,0.5,0.7"
    end

    it "should be able to initialise the marker with an orientation and block passed in" do
      @chart.range_marker(:horizontal) do |marker|
        marker.color = "ff00ff"
        marker.start = 0.5
        marker.end   = 0.7
      end

      @chart.query_params[:chm].should == "r,ff00ff,0,0.5,0.7"
    end

    it "should raise error if the orientation is invalid" do
      lambda { @chart.range_marker(:gibberish,@valid_range_marker) }.should raise_error(ArgumentError)
    end

    it "should raise error if color is not a string" do
      params = @valid_range_marker.except(:color)
      params[:color] = nil
      lambda { @chart.range_marker(:vertical,params) }.should raise_error(ArgumentError)
    end

    it "should raise error if start and end are not numeric" do
      params = @valid_range_marker.except(:start)
      params[:start] = "hi"
      lambda { @chart.range_marker(:vertical,params) }.should raise_error(ArgumentError)

      params = @valid_range_marker.except(:end)
      params[:end] = "hi"
      lambda { @chart.range_marker(:vertical,params) }.should raise_error(ArgumentError)
    end


    it "should raise error if start and end are not within 0 and 1" do
      params = @valid_range_marker.except(:start)
      params[:start] = -1
      lambda { @chart.range_marker(:vertical,params) }.should raise_error(ArgumentError)

      params = @valid_range_marker.except(:end)
      params[:end] = 5
      lambda { @chart.range_marker(:vertical,params) }.should raise_error(ArgumentError)
    end

    it "should raise error if end < start" do
      params = @valid_range_marker.except(:start, :end)
      params[:start] = 0.9
      params[:end]   = 0.7
      lambda { @chart.range_marker(:vertical,params) }.should raise_error(ArgumentError)
    end
  end
end