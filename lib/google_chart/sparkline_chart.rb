module GoogleChart
  class SparklineChart < Base
    include Legend
    include Color
    include DataArray
    include Fills
    include Axis
    include Grid
    include Markers

    data_type :numeric_array

    def initialize(options={}) #:nodoc:
      @chart_type = "ls"
      @show_legend = false
      super(options)
    end
  end
end
