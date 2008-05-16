require 'open-uri'
require 'uri'

module GoogleChart
  class Base
    # Make new method private to avoid direct initialisation
    class <<self ; private :new ; end

    # Wicked metaprogramming hack to :
    # - make the new method public to enable initialisation
    # - add a chart_type attribute to base class
    def self.inherited(subclass) #:nodoc:
      subclass.class_eval do
        attr_reader :chart_type
        class <<self ; public :new ; end
      end
    end

    # Chart width, in pixels
    attr_accessor :width

    # Chart height, in pixels
    attr_accessor :height

    # Chart title
    attr_accessor :title

    # Chart title color (hex value)
    attr_accessor :title_color

    # Chart title font size
    attr_accessor :title_font_size


    # Encoding
    attr_accessor :encoding

    # TODO write doc here
    def initialize(options = {}, &block)
      @width    = 320
      @height   = 200
      @encoding = :simple
      @data = []
      @params = {}
      options.each { |k, v| send("#{k}=", v) }
      yield self if block_given?
    end

    def title=(title) #:nodoc:
      @title = title.gsub("\n", "|")
    end

    # Size in WIDTHxHEIGHT format
    def size
      "#{width}x#{height}"
    end

    # Set the data encoding to one of :simple, :text or :extended
    def encoding=(enc)
      raise ArgumentError.new("unsupported encoding: #{encoding.inspect}") unless GoogleChart::ENCODINGS.include?(enc)
      @encoding = enc
    end

    # Return a hash of the query params that will be converted to the URL
    def query_params
      @params.clear
      add_defaults
      add_data
      add_legends if @legends and show_legend?
      add_labels  if @labels and show_labels?
      add_colors  if @colors
      add_fills   if @fills
      add_axes    if @axes
      add_grid    if @grid
      add_markers if @markers
      add_bar_width_and_spacing if respond_to?(:add_bar_width_and_spacing)
      return @params
    end

    # Returns a URL to access the chart.
    # Use +extras+ to add more parameters that may be unsupported or impossible to construct using gchartrb
    def to_url(extras={})
      query = query_params.merge(extras).collect { |k, v| "#{k}=#{URI.escape(v)}" }.join("&")
      "#{GoogleChart::URL}?#{query}"
    end

    private

    def add_defaults
      @params[:cht] = chart_type
      @params[:chs] = size
    end

    def add_data
      sets = encode_data # calling encode data method of subclass
      prefix = case encoding
               when :simple then "s:"
               when :text then "t:"
               when :extended then "e:"
               end
      @params[:chd] = prefix + sets.join(get_series_separator)
    end

    def get_series_separator
      encoding == :text ? "|" : ","
    end

    def get_data_separator
      encoding == :text ? "," : ""
    end
  end
end
