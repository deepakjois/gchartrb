module GoogleChart
  # This module is used as a mixin for providing legend functionality
  module Label
    def self.included(mod)
      mod.class_eval do
        attr_accessor :show_labels

        def show_labels?
          @show_labels
        end
      end
    end


    private
    def label(label)
      @labels ||= []
      @labels << label
    end

    def add_labels
      @params[:chl] = @labels.join("|") unless @labels.empty?
    end
  end
end


