require 'ostruct'
module GoogleChart
  # This module is used as a mixin for providing grid functionality
  module Grid
    GridLines = Struct.new("GridLines", :x_step, :y_step, :line_segment, :blank_segment)
    def grid(options={})
      grid_lines = GridLines.new
      grid_lines.blank_segment = 0
      options.each { |k,v| grid_lines.send("#{k}=",v) }
      yield grid_lines if block_given?

      validate_grid(grid_lines)
      @grid =  grid_lines
    end

    private
    def add_grid
      [:x_step, :y_step, :line_segment, :blank_segment].collect { |m| @grid.send(m)}.compact.join(",")
      @params[:chg] = [:x_step, :y_step, :line_segment, :blank_segment].collect { |m| @grid.send(m) }.compact.join(",")
    end

    def validate_grid(grid)
      [:x_step, :y_step, :line_segment, :blank_segment].each { |m| raise ArgumentError.new("all properties of grid must be numeric") unless grid.send(m).is_a?(Numeric) }
      raise ArgumentError.new("x_step and y_step must be within 0 to 100") unless (1..100).include?(grid.x_step) and (1..100).include?(grid.y_step)
    end
  end
end
