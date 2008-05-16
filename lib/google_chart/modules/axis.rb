require 'ostruct'
module GoogleChart
  # This module is used as a mixin for providing axis
  module Axis
    AXIS_TYPE_MAPPING = { :top => "t", :bottom => "x", :left => "y", :right => "r" }
    ALIGNMENT_MAPPING = { :center => 0, :left => -1, :right => -1}

    Axis = Struct.new("Axis", :type, :labels, :positions, :range, :color, :font_size, :alignment)

    def axis(type, options={})
      @axes ||= []
      raise ArgumentError.new("Axis type must be :top, :bottom, :left or :right") unless AXIS_TYPE_MAPPING.keys.include?(type)
      axis = Axis.new
      axis.type = type

      options.each { |k,v| axis.send("#{k}=",v) }
      yield axis if block_given?

      validate_axis(axis)
      @axes << axis
    end

    private
    def add_axes
      chxt       = @axes.collect { |axis| "#{AXIS_TYPE_MAPPING[axis.type]}" }
      labels     = @axes.collect { |axis| "#{@axes.index(axis)}:|#{axis.labels.join('|')}" if axis.labels }.compact
      positions  = @axes.collect { |axis| "#{@axes.index(axis)},#{axis.positions.join(',')}" if axis.positions}.compact
      ranges     = @axes.collect { |axis| "#{@axes.index(axis)},#{axis.range.min},#{axis.range.max}" if axis.range }.compact
      styles     = @axes.collect do |axis|
                     style = [axis.color,axis.font_size, ALIGNMENT_MAPPING[axis.alignment]].compact
                     unless style.empty?
                       "#{@axes.index(axis)},#{style.join(',')}"
                     end
                   end.compact

      @params[:chxt] = chxt.join(",")
      @params[:chxl] = labels.join("|") unless labels.empty?
      @params[:chxp] = positions.join("|") unless positions.empty?
      @params[:chxr] = ranges.join("|") unless ranges.empty?
      @params[:chxs] = styles.join("|") unless styles.empty?
    end

    def validate_axis(axis)
      raise ArgumentError.new("color must be a string containing a hex value") unless axis.color == nil or axis.color.is_a?(String)
      raise ArgumentError.new("labels must be an array") unless axis.labels == nil or axis.labels.is_a?(Array)
      raise ArgumentError.new("positions must be an array of numeric values") unless axis.positions == nil or (axis.positions.is_a?(Array) and axis.positions.is_numeric_array?)
      raise ArgumentError.new("font_size must be an integer") unless axis.font_size == nil or axis.font_size.is_a?(Integer)
      raise ArgumentError.new("range must be an range of integer values") unless axis.range == nil or axis.range.is_a?(Range) or axis.range.min.is_a?(Integer)
      raise ArgumentError.new("font_size cannot be specified without a color") if (axis.font_size && axis.color == nil)
      raise ArgumentError.new("alignment cannot be specified without a color") if (axis.alignment && (axis.color == nil or axis.font_size == nil))
      raise ArgumentError.new("alignment must be one of :left, :center, :right") unless (axis.alignment ==nil or ALIGNMENT_MAPPING.keys.include?(axis.alignment))

      unless (axis.labels.to_a.size == axis.positions.to_a.size)
        raise ArgumentError.new("sizes of labels and positions must be the same") unless axis.labels == nil or axis.positions == nil
      end

      if axis.positions and axis.range
        raise ArgumentError.new("positions must be in the specified range") unless axis.positions.all? { |item| axis.range.include?(item)}
      end
    end
  end
end
