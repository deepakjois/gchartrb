module GoogleChart
  # This module is used as a mixin for providing color functionality
  module Color
    private
    def color(color)
      @colors ||= []
      @colors << color
    end

    def add_colors
      @params[:chco] = @colors.compact.join(",") unless @colors.compact.empty?
    end

  end
end
