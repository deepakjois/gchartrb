require File.dirname(__FILE__) + '/base'
module GoogleChart
    class BarChart < Base
      
      attr_accessor :alignment, :stacked
      
      def initialize(chart_size='300x200', chart_title=nil, alignment=:vertical, stacked=false)
          super(chart_size, chart_title)
          @alignment = alignment
          @stacked = stacked
          set_chart_type
          self.show_labels = false
          self.show_legend = true
      end
      
      def alignment=(value)
          @alignment = value
          set_chart_type
      end
      
      def stacked=(stacked)
          @stacked = value
          set_chart_type
      end
      
      def process_data
          if @data.size > 1
              max_value = @data.flatten.max
                join_encoded_data(@data.collect { |series|
                  encode_data(series, max_value)
                })
          else
              encode_data(@data.flatten)
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