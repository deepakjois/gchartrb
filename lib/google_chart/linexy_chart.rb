module GoogleChart
  class LineXYChart < Base
    include Legend
    include Color
    include DataArray
    include Fills
    include Axis
    include Grid
    include Markers

    data_type :numeric_2d_array


    def initialize(options={})
      @chart_type = "lxy"
      @show_legend = false
      super(options)
    end
  end
end
