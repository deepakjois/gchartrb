module GoogleChart
  class ScatterPlot < Base
    include Legend
    include Color
    include DataArray
    include Fills
    include Axis
    include Grid
    include Markers

    data_type :numeric_2d_array

    def initialize(options={})
      @chart_type = "s"
      @show_legend = false
      super(options)
    end

    def point_sizes(values)
      raise ArgumentError.new("point sizes should be an array") unless values.is_a?(Array)
      raise ArgumentError.new("All values for point size must be integers") unless values.is_numeric_array?
      raise ArgumentError.new("Point size array must not be bigger than the dataset size") unless @data.first.length == values.length
      @point_sizes = values
    end

    private
    def encode_data
      sets = super
      unless @point_sizes.empty?
        sets << @point_sizes.collect { |d| GoogleChart::encode(encoding,d,@point_sizes.max) }.join(get_data_separator)
      end
    end
  end
end
