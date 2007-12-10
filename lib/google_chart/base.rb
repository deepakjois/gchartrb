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

        attr_accessor :chs, :cht, :chtt, :data_encoding, :params, :show_legend, :show_labels 
    
        # Define friendly aliases (FIXME probably a bad idea. Fix later)
        alias_attr_accessor :chart_title, :chtt
        alias_attr_accessor :chart_size, :chs
        alias_attr_accessor :chart_type, :cht
    
        def initialize(chart_size, chart_title)
            self.params = Hash.new
            @labels = []
            @data   = []
            @colors = []
            @axis   = []
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
            add_axis
            add_grid  
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
        
        def fill(bg_or_c, type, options = {})
            case bg_or_c
                when :background
                    @background_fill = "bg," + process_fill_options(type, options)
                when :chart
                    @chart_fill = "c," + process_fill_options(type, options)
            end
        end
        
        def axis(type, options = {})
          raise "Illegal axis type" unless [:x, :y, :right, :top].member?(type)          
          @axis << [type, options]
        end
        
        def grid(options={})
          @grid_str = "#{options[:x_step].to_f},#{options[:y_step].to_f}"
          if options[:length_segment] or options[:length_blank]
             @grid_str += ",#{options[:length_segment].to_f},#{options[:length_blank].to_f}"
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
             fill_opt = [@background_fill, @chart_fill].compact.join("|")
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
        
        def add_axis          
            chxt = []
            chxl = []
            chxp = []
            chxr = []                       
            chxs = []
            # Process params
            @axis.each_with_index do |axis, idx|
              # Find axis type
              case axis.first
                when :x
                  chxt << "x"
                when :y
                  chxt << "y"
                when :top
                  chxt << "r"
                when :right
                  chxt << "t"
              end
              
              # Axis labels
              axis_opts = axis.last
              
              if axis_opts[:labels]
                chxl[idx] = "#{idx}:|" + axis_opts[:labels].join("|")
              end
              
              # Axis positions
              if axis_opts[:positions]
                chxp[idx] = "#{idx}," + axis_opts[:positions].join(",")
              end
              
              # Axis range
              if axis_opts[:range]
                chxr[idx] = "#{idx},#{axis_opts[:range].first},#{axis_opts[:range].last}"                
              end
              
              # Axis Styles
              if axis_opts[:color] or axis_opts[:font_size] or axis_opts[:alignment]
                if axis_opts[:alignment]
                  alignment = case axis_opts[:alignment]
                                when :center
                                   0
                                when :left
                                  -1
                                when :right
                                   1 
                                else
                                   nil
                              end
                end
                chxs[idx] = "#{idx}," + [axis_opts[:color], axis_opts[:font_size], alignment].compact.join(",")
              end
            end
            
            # Add to params hash
            params.merge!({ :chxt => chxt.join(",") })          unless chxt.empty?
            params.merge!({ :chxl => chxl.compact.join("|") })  unless chxl.compact.empty?
            params.merge!({ :chxp => chxp.compact.join("|") })  unless chxp.compact.empty?
            params.merge!({ :chxr => chxr.compact.join("|") })  unless chxr.compact.empty?
            params.merge!({ :chxs => chxs.compact.join("|") })  unless chxs.compact.empty?
        end
        
        def add_grid
          params.merge!({ :chg => @grid_str }) if @grid_str
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