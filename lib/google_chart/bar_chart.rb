module GoogleChart
  class BarChart < Base
    include Legend
    include Color
    include DataArray
    include Fills
    include Axis
    include Grid
    include Markers

    data_type :numeric_array

    attr_accessor :orientation, :grouping, :bar_width, :bar_spacing, :group_spacing

    ORIENTATIONS = [:horizontal, :vertical]
    GROUPINGS    = [:grouped, :stacked]

    def initialize(options={}) #:nodoc:
      @orientation = :vertical
      @grouping    = :grouped
      set_chart_type
      @show_legend = true
      super(options)
    end


    def orientation=(o)
      raise ArgumentError.new("Orientation can only be :vertical or :horizontal") unless ORIENTATIONS.include?(o)
      @orientation = o
      set_chart_type
    end

    def grouping=(g)
      raise ArgumentError.new("Grouping can only be :grouped or :stacked") unless GROUPINGS.include?(g)
      @grouping = g
      set_chart_type
    end

    def set_chart_type
      @chart_type = (
                     if    @orientation == :horizontal and @grouping == :grouped then "bhg"
                     elsif @orientation == :horizontal and @grouping == :stacked then "bhs"
                     elsif @orientation == :vertical   and @grouping == :grouped then "bvg"
                     elsif @orientation == :vertical   and @grouping == :stacked then "bvs"
                     end
                    )
    end

    def bar_width=(width)
      raise ArgumentError.new("bar width should be in integer") unless width.is_a?(Integer)
      @bar_width = width
    end

    def bar_spacing=(spacing)
      raise ArgumentError.new("bar spacing should be in integer") unless spacing.is_a?(Integer)
      raise ArgumentError.new("cannot specify bar spacing without specifying bar width first") unless @bar_width
      @bar_spacing = spacing
    end

    def group_spacing=(spacing)
      raise ArgumentError.new("bar spacing should be in integer") unless spacing.is_a?(Integer)
      raise ArgumentError.new("cannot specify group spacing without specifying bar width first") unless @bar_width
      raise ArgumentError.new("cannot specify group spacing without specifying bar spacing first") unless @bar_spacing
      @group_spacing = spacing
    end

    def add_bar_width_and_spacing
      str = "#{@bar_width}" if @bar_width
      str+= ",#{@bar_spacing}" if @bar_spacing
      str+= ",#{@group_spacing}" if @group_spacing
      @params[:chbh] = str if str
    end

    def encode_data
      # override encode_data to set custom max value for stacked charts (unless max is already set)
      if grouping == :stacked and not self.max
        # set max value to the max value of sums
        self.max = @data.inject(Array.new(@data.first.size,0)) { |sum_series, series|  sum_series.zip(series).collect { |d| d.first + d.last } }.max
      end
      super
    end
  end
end
