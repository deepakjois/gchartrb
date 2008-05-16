module GoogleChart
    class PieChart < Base
      include Fills
      include Color
      include DataArray
      include Label

      data_type :numeric

      attr_accessor :is_3d

      def initialize(options={})
        @is_3d = false
        set_chart_type
        @label ||=
        @show_labels = true
        super(options)
      end

      def is_3d=(three_d)
        @is_3d = three_d
        set_chart_type
      end

      def is_3d?
        self.is_3d
      end

      def set_chart_type
        if is_3d?
          @chart_type = "p3"
        else
          @chart_type = "p"
        end
      end

      def data(label,data,color=nil)
        raise ArgumentError.new("data should be an integer value") unless data.is_a?(Numeric)
        @data << data
        label(label)
        color(color)
      end
    end
end
