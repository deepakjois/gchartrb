require File.dirname(__FILE__) + '/base'
module GoogleChart
    class PieChart < Base

        attr_accessor :is_3d

        # Initializes a Pie Chart object with a +chart_size+ and +chart_title+. Specify <tt>is_3d</tt> as +true+ to generate a 3D Pie chart
        def initialize(chart_size='300x200', chart_title=nil, is_3d = false)
            super(chart_size, chart_title)
            self.is_3d = is_3d
            self.show_labels = true
            self.show_legend = false
        end

        # Set this value to <tt>true</tt> if you want the Pie Chart to be rendered as a 3D image
        def is_3d=(value)
            if value
                self.chart_type = :p3
            else
                self.chart_type = :p
            end
        end

        def process_data
            encode_data(@data)
        end
    end
end