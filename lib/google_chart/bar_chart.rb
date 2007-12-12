require File.dirname(__FILE__) + '/base'
module GoogleChart
    # Generates a Bar Chart. You can specify the alignment(horizontal or vertical) and whether you want the bars to be grouped or stacked
    # ==== Examples
    #     bc = GoogleChart::BarChart.new('800x200', "Bar Chart", :vertical, false)
    #     bc.data "Trend 1", [5,4,3,1,3,5], '0000ff'     
    class BarChart < Base
      
      attr_accessor :alignment, :stacked
      
      # Specify the 
      # * +chart_size+ in WIDTHxHEIGHT format
      # * +chart_title+ as a string
      # * +alignment+ as either <tt>:vertical</tt> or <tt>:horizontal</tt>
      # * +stacked+ should be +true+ if you want the bars to be stacked, false otherwise
      def initialize(chart_size='300x200', chart_title=nil, alignment=:vertical, stacked=false)
          super(chart_size, chart_title)
          @alignment = alignment
          @stacked = stacked
          set_chart_type
          self.show_labels = false
          self.show_legend = true
      end
      
      # Set the alignment to either <tt>:vertical</tt> or <tt>:horizontal</tt>
      def alignment=(value)
          @alignment = value
          set_chart_type
      end
      
      # If you want the bar chart to be stacked, set the value to <tt>true</tt>, otherwise set the value to <tt>false</tt> to group it.
      def stacked=(stacked)
          @stacked = value
          set_chart_type
      end

      def process_data
          if @data.size > 1              
                join_encoded_data(@data.collect { |series|
                  encode_data(series, max_data_value)
                })
          else
              encode_data(@data.flatten,max_data_value)
          end
      end
      
      private
      def set_chart_type
          # Set chart type
          if alignment == :vertical and stacked == false
              self.chart_type = :bvg
          elsif alignment == :vertical and stacked == true
              self.chart_type = :bvs
          elsif alignment == :horizontal and stacked == false
              self.chart_type = :bhg
          elsif alignment == :horizontal and stacked == true
              self.chart_type = :bhs
          end          
      end
    end
end