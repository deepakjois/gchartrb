require File.dirname(__FILE__) + '/base'
module GoogleChart
    # Generates a Line Chart. You can specify whether it is a standard line chart or an XY Line chart
    # 
    # ==== Examples
    #
    #      # Line Chart
    #      lc = GoogleChart::LineChart.new('320x200', "Line Chart", false)
    #      lc.data "Trend 1", [5,4,3,1,3,5,6], '0000ff'
    #      lc.data "Trend 2", [1,2,3,4,5,6], '00ff00'
    #      lc.data "Trend 3", [6,5,4,3,2,1], 'ff0000'
    #      puts lc.to_url
    #
    #      # Line XY Chart
    #      lcxy =  GoogleChart::LineChart.new('320x200', "Line XY Chart", true)
    #      lcxy.data "Trend 1", [[1,1], [2,2], [3,3], [4,4]], '0000ff'
    #      lcxy.data "Trend 2", [[4,5], [2,2], [1,1], [3,4]], '00ff00'
    #      puts lcxy.to_url    
    class LineChart < Base
        attr_accessor :is_xy
        
        # Initializes a Line Chart object with a +chart_size+ and +chart_title+. Specify +is_xy+ as +true+ to generate a Line XY chart
        def initialize(chart_size='300x200', chart_title=nil, is_xy=false)
            super(chart_size, chart_title)
            self.is_xy = is_xy
        end
        
        # If you want the Line Chart to be an XY chart, set the value to <tt>true</tt>, otherwise <tt>false</tt>.
        #
        # ==== Examples
        # A line chart takes data in the following format (both X and Y coordinates need to be specified)
        #     lcxy =  GoogleChart::LineChart.new('320x200', "Line XY Chart", true)
        #     lcxy.data "Trend 1", [[1,1], [2,2], [3,3], [4,4]], '0000ff'
        #     puts lcxy.to_url         
        def is_xy=(value)
            @is_xy = value
            if value
                self.chart_type = :lxy
            else
                self.chart_type = :lc
            end
        end
                
        def process_data
            if self.is_xy or @data.size > 1
                if self.is_xy # XY Line graph data series
                  max_value = @data.flatten.max
                 x_data = @data.collect do |series|
                     series.collect { |val| val.first }
                 end
                 
                 y_data = @data.collect do |series|
                      series.collect { |val| val.last }
                 end
                  
                  encoded_data = []
                  @data.size.times { |i|
                      # Interleave X and Y co-ordinate data
                      encoded_data << join_encoded_data([encode_data(x_data[i],max_value), encode_data(y_data[i],max_value)])
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