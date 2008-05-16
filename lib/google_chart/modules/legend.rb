module GoogleChart
  # This module is used as a mixin for providing legend functionality
  module Legend
    def self.included(mod)
      mod.class_eval do
        attr_accessor :show_legend

        def show_legend?
          @show_legend
        end
      end
    end

    private
    def legend(legend)
      @legends ||= []
      @legends << legend
    end

    def add_legends
      @params[:chdl] = @legends.join("|") unless @legends.empty?
    end
  end
end
