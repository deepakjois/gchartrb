require File.dirname(__FILE__) + '/base'
module GoogleChart
  class LineChart < Base
    attr_accessor :is_xy

    def initialize(chart_size='300x200', chart_title=nil, is_xy=false)
      super(chart_size, chart_title)
      self.is_xy = is_xy
    end

    def is_xy=(value)
      @is_xy = value
      if value
        self.chart_type = :lxy
      else
        self.chart_type = :lc
      end
    end

    def max_x_value
      x_data.flatten.max
    end

    def max_y_value
      y_data.flatten.max
    end

    def x_data
      @data.collect do |series|
        series.collect { |val| val.first }
      end
    end

    def y_data
      @data.collect do |series|
        series.collect { |val| val.last }
      end
    end

    def process_data
      if self.is_xy or @data.size > 1
        if self.is_xy # XY Line graph data series
          encoded_data = []
          @data.size.times { |i|
            # Interleave X and Y co-ordinate data
            encoded_data << join_encoded_data([encode_data(x_data[i],max_x_value), encode_data(y_data[i],max_y_value)])
          }
          join_encoded_data(encoded_data)
        else # Line graph multiple data series
          max_value = @data.flatten.max
          join_encoded_data(@data.collect { |series|
            encode_data(series, max_value)
          })
        end
      else
        encode_data(@data.flatten)
      end
    end
  end
end
