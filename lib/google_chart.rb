require File.dirname(__FILE__) + "/core_ext"
%w(legend color data_array fills axis grid markers label).each do |mod|
    require File.dirname(__FILE__) + "/google_chart/modules/#{mod}"
end

%w(base line_chart linexy_chart sparkline_chart scatter_plot bar_chart radar_chart venn_diagram pie_chart map_chart qr_code).each do |type|
    require File.dirname(__FILE__) + "/google_chart/#{type}"
end

module GoogleChart
  # Blatantly copied from GChart (http://gchart.rubyforge.org)
  URL   = "http://chart.apis.google.com/chart"

  SIMPLE_CHARS = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
  EXTENDED_CHARS = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + %w[- .]
  EXTENDED_PAIRS = EXTENDED_CHARS.collect { |first| EXTENDED_CHARS.collect { |second| first + second } }.flatten
  ENCODINGS = [:simple, :text, :extended]

  class <<self

    # Encode +n+ as a string. +n+ is normalized based on +max+.
    # Blatantly copied from GChart (http://gchart.rubyforge.org)
    def encode(encoding, n, max)
      case encoding
      when :simple
        return "_" if n.nil?
        SIMPLE_CHARS[((n.zero? ? 0 : n/max.to_f) * (SIMPLE_CHARS.size - 1)).round]
      when :text
        return "-1" if n.nil?
        ((((n.zero? ? 0 : n/max.to_f) * 1000.0).round)/10.0).to_s
      when :extended
        return "__" if n.nil?
        EXTENDED_PAIRS[max.zero? ? 0 : ((n/max.to_f) * (EXTENDED_PAIRS.size - 1)).round]
      else
        raise ArgumentError, "unsupported encoding: #{encoding.inspect}"
      end
    end
  end
end
