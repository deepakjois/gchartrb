module GoogleChart

    class VennDiagram < Base
      include Legend
      include Fills
      include Color
      include DataArray

      data_type :numeric

        def initialize(options={})
          @chart_type="v"
          @show_legend = false
          @intersections = []
          super(options)
        end

        # Specify the intersections of the circles in the Venn Diagram. See the Rdoc for class for sample
        def intersections(*values)
          raise ArgumentError.new("Please intialise the data first before adding intersections") if @data.empty?
          raise ArgumentError.new("You can have at most three intersections") if values.size > 4
          raise ArgumentError.new("You cannot have more intersections than data points") if values.size > (@data.size + 1)
          raise ArgumentError.new("all values must be integers") unless values.all? { |v| v.is_a?(Integer) }
          @intersections = values
        end

        def data(legend, data, color = nil)
          raise ArgumentError.new("data should be an integer value") unless data.is_a?(Integer)
          raise ArgumentError.new("you can only insert upto 3 data points") if @data.size == 3
          @data << data
          legend(legend)
          color(color)
        end
        private
        def encode_data
          @data.push(0) until @data.size == 3
          @data = @data + @intersections unless @intersections.empty?
          super
        end
    end
end
