require File.dirname(__FILE__) + '/base'
module GoogleChart
    class VennDiagram < Base
                
        def initialize(chart_size='300x200', chart_title=nil)
            super(chart_size, chart_title)
            self.cht = :v
            @intersections = [] 
        end
         
        def process_data          
          encode_data(@data + @intersections)
        end
         
        def intersections(*values)            
          @intersections = values
        end
    end
end