require File.dirname(__FILE__) + '/base'
module GoogleChart
    class PieChart < Base

        attr_accessor :is_3d

        def initialize(chart_size='300x200', chart_title=nil, is_3d = false)
            super(chart_size, chart_title)
            self.is_3d = is_3d
        end

        def is_3d=(value)
            if value
                self.cht = :p3
            else
                self.cht = :p
            end
        end

        def process_data
            encode_data(@data)
        end
    end
end