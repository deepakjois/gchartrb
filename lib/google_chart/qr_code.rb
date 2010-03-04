module GoogleChart
  class QrCode < Base
    attr_accessor :output_encoding, :data, :error_correction_level, :margin

    def initialize(options={})
      @output_encoding = 'UTF-8'
      @error_correction_level = 'L'
      @margin = 4
      @chart_type = 'qr'
      super(options)
    end

    def data(data)
      @data = data
    end

    def add_data
      @params[:chl] = @data
    end

    def add_additional_parameters
      @params[:choe] = @output_encoding
      @params[:chld] = "#{@error_correction_level}|#{@margin}"
    end
  end
end
