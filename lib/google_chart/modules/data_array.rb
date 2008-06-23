module GoogleChart
  # This module is used as a mixin for providing data functionality
  module DataArray
    def self.included(mod)#:nodoc:
      # Extend class methods
      mod.send(:extend,ClassMethods)
    end

    def data(legend, series, color = nil)
      raise ArgumentError.new("Invalid value for series data") unless series.send(self.class.get_data_type)
      @data << series
      legend(legend)
      color(color)
    end

    def encode_data
      if @data.first.is_a?(Numeric)
        max_val = (self.max or @data.max)
        sets = [@data.collect { |d| GoogleChart::encode(encoding,d,max_val)}.join(get_data_separator)]
      elsif @data.first.is_numeric_2d_array? # Check if each data is an array of 2d values
        x_values = @data.collect { |item| item.x_values }
        y_values = @data.collect { |item| item.y_values }

        x_max_val = (max_x or x_values.flatten.max)
        y_max_val = (max_y or y_values.flatten.max)

        x_sets = x_values.collect { |set| set.collect{ |d| GoogleChart::encode(encoding,d,x_max_val)}.join(get_data_separator) }
        y_sets = y_values.collect { |set| set.collect{ |d| GoogleChart::encode(encoding,d,y_max_val)}.join(get_data_separator) }

        sets = x_sets.zip(y_sets).collect { |item| item.join(get_series_separator) }
      elsif @data.first.is_numeric_array?
        max_val = (self.max or @data.flatten.max)
        sets = @data.collect { |set| set.collect{ |d| GoogleChart::encode(encoding,d,max_val)}.join(get_data_separator) }
      end
      return sets
    end

    module ClassMethods
      def data_type(type) #:nodoc:
        raise ArgumentError.new("Invalid data type, must be either :numeric, :numeric_array or :numeric_2d_array") unless [:numeric, :numeric_array, :numeric_2d_array].include?(type)
        # This is the *instance variable* of the *singleton class* ;)
        @data_type = type

        if @data_type == :numeric_2d_array
          attr_accessor :max_x, :max_y
        else
          attr_accessor :max
        end
      end

      def get_data_type #:nodoc:
        raise ArgumentError.new("Data type not specified") unless @data_type
        "is_#{@data_type}?".to_sym
      end
    end
  end
end
