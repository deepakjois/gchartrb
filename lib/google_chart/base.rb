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

        attr_accessor :chart_size, :chart_type, :chart_title, :data_encoding, :params, :show_legend, :show_labels 
    
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
        
        # Generates the URL string that can be used to retrieve the graph image in PNG format.
        # Use this after assigning all the properties to the graph
        # You can pass in additional params as a hash for features that may not have been implemented
        # For e.g
        #      lc = GoogleChart::LineChart.new('320x200', "Line Chart", false)
        #      lc.data "Trend 1", [5,4,3,1,3,5,6], '0000ff'
        #      lc.data "Trend 2", [1,2,3,4,5,6], '00ff00'
        #      lc.data "Trend 3", [6,5,4,3,2,1], 'ff0000'
        #      puts lc.to_url({:chm => "000000,0,0.1,0.11"}) # Single black line as a horizontal marker        
        def to_url(extras={})
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
            
            params.merge!(extras)
            query_string = params.map { |k,v| "#{k}=#{URI.escape(v.to_s)}" }.join('&')
            BASE_URL + query_string
        end
        
        # Adds the data to the chart, according to the type of the graph being generated.
        #
        # [+name+] is a string containing a label for the data.
        # [+value+] is either a number or an array of numbers containing the data. Pie Charts and Venn Diagrams take a single number, but other graphs require an array of numbers
        # [+color+ (optional)] is a hexadecimal RGB value for the color to represent the data
        # 
        # ==== Examples
        #
        # for GoogleChart::LineChart (normal)
        #    lc.data "Trend 1", [1,2,3,4,5], 'ff00ff'
        #
        # for GoogleChart::LineChart (XY chart)
        #    lc.data "Trend 2", [[4,5], [2,2], [1,1], [3,4]], 'ff00ff'
        #
        # for GoogleChart::PieChart
        #    lc.data "Apples", 5, 'ff00ff'
        #    lc.data "Oranges", 7, '00ffff'
        def data(name, value, color=nil)
            @data << value
            @labels << name
            @colors << color if color
        end
        
        # Adds a background or chart fill. Call this option twice if you want both a background and a chart fill
        # [+bg_or_c+] Can be one of <tt>:background</tt> or <tt>:chart</tt> depending on the kind of fill requested
        # [+type+] Can be one of <tt>:solid</tt>, <tt>:gradient</tt> or <tt>:stripes</tt>
        # [+options+] : Options depend on the type of fill selected above
        #
        # ==== Options
        # For <tt>:solid</tt> type
        # * A <tt>:color</tt> option which specifies the RGB hex value of the color to be used as a fill. For e.g <tt>lc.fill(:chart, :solid, {:color => 'ffcccc'})</tt>
        #
        # For <tt>:gradient</tt> type
        # * An <tt>:angle</p>, which is the angle of the gradient between 0(horizontal) and 90(vertical)
        # * A <tt>:color</tt> option which is a 2D array containing the colors and an offset each, which specifies at what point the color is pure where: 0 specifies the right-most chart position and 1 the left-most. e,g <tt>lc.fill :background, :gradient, :angle => 0,  :color => [['76A4FB',1],['ffffff',0]]</tt>
        # 
        # For <tt>:stripes</tt> type
        # * An <tt>:angle</p>, which is the angle of the stripe between 0(horizontal) and 90(vertical)
        # * A <tt>:color</tt> option which is a 2D array containing the colors and width value each, which must be between 0 and 1 where 1 is the full width of the chart. for e.g <tt>lc.fill :chart, :stripes, :angle => 90, :color => [ ['76A4FB',0.2], ['ffffff',0.2] ]</tt>
        def fill(bg_or_c, type, options = {})
            case bg_or_c
                when :background
                    @background_fill = "bg," + process_fill_options(type, options)
                when :chart
                    @chart_fill = "c," + process_fill_options(type, options)
            end
        end
        
        # Adds an axis to the graph. Not applicable for Pie Chart (GoogleChart::PieChart) or Venn Diagram (GoogleChart::VennDiagram)
        # 
        # [+type+] is a symbol which can be one of <tt>:x</tt>, <tt>:y</tt>, <tt>:right</tt>, <tt>:top</tt> 
        # [+options+] is a hash containing the options (see below)
        # 
        # ==== Options
        # Not all the options are mandatory.
        # [<tt>:labels</tt>] An array containing the labels for the axis
        # [<tt>:position</tt>] An Array containing the positions for the labels
        # [<tt>:range</tt>] An array containing 2 elements, the start value and end value
        # 
        # axis styling options have to be specified as follows
        # [<tt>:color</tt>] Hexadecimal RGB value for the color to represent the data for the axis labels
        # [<tt>:font_size</tt>] Font size of the labels in pixels
        # [<tt>:alignment</tt>] can be one of <tt>:left</tt>, <tt>:center</tt> or <tt>:right</tt>
        # 
        # ==== Examples
        #     lc.axis :y, :range => [0,6], :color => 'ff00ff', :font_size => 16, :alignment => :center
        #       
        def axis(type, options = {})
          raise "Illegal axis type" unless [:x, :y, :right, :top].member?(type)          
          @axis << [type, options]
        end
        
        # Adds a grid to the graph. Applicable only for Line Chart (GoogleChart::LineChart) and Scatter Chart (GoogleChart::ScatterChart)
        #
        # [+options+] is a hash containing the options (see below) 
        #
        # === Options
        # [<tt>:xstep</tt>] X axis step size
        # [<tt>:ystep</tt>] Y axis step size
        # [<tt>:length_segment</tt> (optional)] Length of the line segement. Useful with the :length_blank value to have dashed lines
        # [<tt>:length_blank</tt> (optional)] Length of the blank segment. use 0 if you want a solid grid
        # 
        # === Examples
        #     lc.grid :x_step => 5, :y_step => 5, :length_segment => 1, :length_blank => 0
        #
        
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
            params.merge!({:cht => chart_type})
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
                    simple_encode(values, max_value)
                when :text
                    text_encode(values, max_value)
                when :extended
                    extended_encode(values, max_value)
                else
                    raise "Illegal Encoding Specified"
            end
        end
        
        def simple_encode(values, max_value=nil)
            alphabet_length = 61
            max_value = values.max unless max_value

            chart_data = values.collect do |val|              
                    if val.to_i >=0
                      if max_value == 0  
                        SIMPLE_ENCODING[0]
                      else
                        SIMPLE_ENCODING[(alphabet_length * val / max_value).to_i]
                      end
                    else
                        "_"
                    end
            end
            
            return chart_data.join('')
        end
        
        def text_encode(values, max_value=nil)
             max_value = values.max unless max_value
             values.inject("") { |sum, v|
               if max_value == 0
                 sum += "0,"
               else
                 sum += ( "%.1f" % (v*100/max_value) ) + ","
               end
             }.chomp(",")
        end
        
        def extended_encode(values, max_value)
            max_value = values.max unless max_value
            values.collect { |v| 
              if max_value == 0
                @@complex_encoding[0]
              else
                @@complex_encoding[(v * 4095/max_value).to_i]
              end
            }.join('')
        end
        
        def join_encoded_data(encoded_data)
            encoded_data.join((self.data_encoding == :simple) ? "," : "|")
        end
        
        ## Applicable to Line Charts and Scatter Charts only
        
        def max_x_value
          x_data.flatten.max
        end

        def max_y_value
          y_data.flatten.max
        end

        def x_data
          @data.collect do |series|
            series.collect { |val| val.first }
          end
        end

        def y_data
          @data.collect do |series|
            series.collect { |val| val.last }
          end
        end        
    end
end