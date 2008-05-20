require 'ostruct'
module GoogleChart
  # This module is used as a mixin for providing shape markers, and horizontal and vertical range markers
  module Markers
    ORIENTATION = {:horizontal => "r", :vertical => "R" }

    SHAPES = {
                :arrow                => "a",
                :cross                => "c",
                :diamond              => "d",
                :circle               => "o",
                :square               => "s",
                :text                 => "t",
                :vertical_line_top    => "v",
                :vertical_line_bottom => "V",
                :horizontal_line      => "h",
                :x                    => "x"
             }

   PRIORITY = { :high => 1, :low => -1 }

    RangeMarker = Struct.new("RangeMarker", :orientation, :color, :start, :end)
    ShapeMarker = Struct.new("ShapeMarker", :shape, :color, :data_set, :data_point, :size, :priority, :text)

    def shape_marker(shape, options={})
      @markers ||= []
      marker = ShapeMarker.new
      marker.shape = shape

      options.each { |k,v| marker.send("#{k}=",v) }
      yield marker if block_given?

      validate_shape_marker(marker)
      values = [:shape, :color, :data_set, :data_point, :size, :priority].collect { |m| marker.send(m) }.compact
      values[0] = SHAPES[marker.shape]
      values[0] += (marker.text.gsub(" ","+")) if marker.shape == :text
      values[5] = PRIORITY[marker.priority] if values[5]
      @markers << values.join(",")
    end

    def range_marker(orientation, options={})
      @markers ||= []
      marker = RangeMarker.new
      marker.orientation = orientation

      options.each { |k,v| marker.send("#{k}=",v) }
      yield marker if block_given?

      validate_range_marker(marker)

      values = [:orientation, :color, :start, :end].collect { |m| marker.send(m) }
      values[0] = ORIENTATION[marker.orientation]
      values.insert 2, "0"
      @markers << values.join(",")
    end

    private
    def add_markers
      @params[:chm] = @markers.join("|")
    end

    def validate_range_marker(marker)
      raise ArgumentError.new("Invalid orientation value. Must be one of :horizontal or :vertical") unless ORIENTATION.keys.include?(marker.orientation)
      raise ArgumentError.new("start and end values must be numeric") unless marker.start.is_a?(Numeric) and marker.end.is_a?(Numeric)
      raise ArgumentError.new("start and end values must be within 0 and 1") unless (0..1).include?(marker.start) and (0..1).include?(marker.end)
      raise ArgumentError.new("start value must be less than end value") unless marker.start < marker.end
      raise ArgumentError.new("start value must be less than end value") unless marker.color.is_a?(String)
    end

    def validate_shape_marker(marker)
      raise ArgumentError.new("Invalid shape") unless SHAPES.keys.include?(marker.shape)
      raise ArgumentError.new("Invalid color. :color must be a string") unless marker.color.is_a?(String)
      raise ArgumentError.new("Invalid data set value. Must be and integer less than #{@data.length}") unless marker.data_set.is_a?(Integer) and
                                                                                                              marker.data_set < @data.length and
                                                                                                              marker.data_set >= 0

      raise ArgumentError.new("Invalid data set value. Must be and integer less than #{@data[marker.data_set].length}") unless marker.data_point.is_a?(Integer) and
                                                                                                                               marker.data_point < @data[marker.data_set].length and
                                                                                                                               marker.data_point >= 0
      raise ArgumentError.new("Invalid priority. :priority must be either :low or :high") unless marker.priority == nil or
                                                                                                 PRIORITY.keys.include?(marker.priority)

      raise ArgumentError.new("Size must be an integer") unless marker.size.is_a?(Integer)
      raise ArgumentError.new("Text should not be specified if marker is not text") if marker.text and marker.shape != :text
      raise ArgumentError.new("Text should be specified (using :text) if marker is text") if marker.text == nil and marker.shape == :text
    end
  end
end
