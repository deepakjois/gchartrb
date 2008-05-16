module GoogleChart
  class RadarChart < Base
    include Legend
    include Color
    include DataArray
    include Fills
    include Axis
    include Grid
    include Markers

    data_type :numeric_array

    # Indicates if the data points should be connected by splines
    attr_accessor :splines

    def initialize(options={}) #:nodoc:
      @splines = false
      set_chart_type
      @show_legend = false
      super(options)
    end

    def set_chart_type
      if @splines then @chart_type = "rs" ; else @chart_type = "r" ; end
    end

    def splines=(connect_with_splines)
      raise ArgumentError.new("splines must be a boolean value") unless [true, false].include?(connect_with_splines)
      @splines = connect_with_splines
      set_chart_type
    end
  end
end
