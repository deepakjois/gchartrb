require 'uri'

module GoogleChart
    class Base
        BASE_URL = "http://chart.apis.google.com/chart?"
        
        SIMPLE_ENCODING = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'.split('');
        COMPLEX_ENCODING_ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-.'.split('');
        @@complex_encoding = []
        COMPLEX_ENCODING_ALPHABET.each_with_index do |outer,index_outer|
            COMPLEX_ENCODING_ALPHABET.each_with_index do |inner, index_inner|
                @@complex_encoding[index_outer * 64 + index_inner] = outer + inner
            end
        end
        # puts @@complex_encoding.inspect
        
        attr_accessor :chs, :cht, :chtt, :data_encoding, :params, :show_legend, :show_labels 
    
        # Define friendly aliases
        alias_attr_accessor :chart_title, :chtt
        alias_attr_accessor :chart_size, :chs
        alias_attr_accessor :chart_type, :cht
    
        def initialize(chart_size, chart_title)
            self.params = Hash.new
            @labels = []
            @data   = []
            @colors = []
            self.chart_size    = chart_size
            self.chart_title   = chart_title            
            self.data_encoding = :simple
            self.show_legend   = true
            self.show_labels   = false
        end
        
        def to_url
            params.clear
            set_size
            set_type
            set_colors
            set_fill_options
            add_data
            add_labels(@labels) if show_labels
            add_legend(@labels) if show_legend
            add_title  if chart_title.to_s.length > 0 
            
            query_string = params.map { |k,v| "#{k}=#{URI.escape(v.to_s)}" }.join('&')
            BASE_URL + query_string
        end
        
        def data(name, value, color=nil)
            @data << value
            @labels << name
            @colors << color if color
        end
        
        def fill(bg_or_c, type, options={})
            case bg_or_c
                when :background
                    @background_fill = "bg," + process_fill_options(type, options)
                when :chart
                    @chart_fill = "c," + process_fill_options(type, options)
            end
        end
            
        protected
        
        def process_fill_options(type, options)
            case type
              when :solid
                  "s,#{options[:color]}"
              when :gradient
                  "lg,#{options[:angle]}," + options[:color].collect { |o| "#{o.first},#{o.last}" }.join(",")
              when :stripes
                  "ls,#{options[:angle]}," + options[:color].collect { |o| "#{o.first},#{o.last}" }.join(",")
            end
                            
        end
        
        def set_type
            params.merge!({:cht => cht})
        end
        
        def set_size
            params.merge!({:chs => chart_size})
        end
        
        def set_colors
          params.merge!({:chco => @colors.collect{|c| c.downcase}.join(",")  }) if @colors.size > 0
        end
        
        def set_fill_options
             fill_opt = [@background_fill, @chart_fill].select{|v| v}.join("|") # A convoluted but quick way of eliminating null values
             params.merge!({:chf => fill_opt}) if fill_opt.length > 0
        end
        
        def add_labels(labels)
            params.merge!({:chl => labels.collect{|l| l.to_s}.join("|") }) 
        end                
    
        def add_legend(labels)
            params.merge!({:chdl => labels.collect{ |l| l.to_s}.join("|")})
        end
        
        def add_title
            params.merge!({:chtt => chart_title})
        end
        
        def add_data
            converted_data = process_data
            case data_encoding
                when :simple
                    converted_data = "s:" + converted_data
                when :text
                    converted_data = "t:" + converted_data
                when :extended
                    converted_data = "e:" + converted_data
                else
                    raise "Illegal Encoding Specified"
            end
            params.merge!({:chd => converted_data})
        end
        
        def encode_data(values, max_value=nil)
            case data_encoding
                when :simple
                    simple_encode(values)
                when :text
                    text_encode(values)
                when :extended
                    extended_encode(values)
                else
                    raise "Illegal Encoding Specified"
            end
        end
        
        def simple_encode(values, max_value=nil)
            alphabet_length = 61
            max_value = values.max unless max_value

            chart_data = values.collect do |val|              
                    if val.to_i >=0  
                        SIMPLE_ENCODING[(alphabet_length * val / max_value).to_i]
                    else
                        "_"
                    end
            end
            
            return chart_data.join('')
        end
        
        def text_encode(values, max_value=nil)
             max_value = values.max unless max_value
             values.inject("") { |sum, v|
               sum += ( "%.1f" % (v*100/max_value) ) + ","
             }.chomp(",")
        end
        
        def extended_encode(values, max_value)
            max_value = values.max unless max_value
            values.collect { |v| @@complex_encoding[(v * 4095/max_value).to_i]}.join('')
        end
        
        def join_encoded_data(encoded_data)
            encoded_data.join((self.data_encoding == :simple) ? "," : "|")
        end
    end
end