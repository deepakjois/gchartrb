module GoogleChart
  class MapChart < Base
    include Color
    include DataArray
    include Fills

    GEOGRAPHICAL_AREAS = [ :africa, :asia, :europe, :middle_east, :south_america, :usa, :world ]
    ISO_3166_1_ALPHA_2 = [ :AF, :AX, :AL, :DZ, :AS, :AD, :AO, :AI, :AQ, :AG, :AR, :AM, :AW, :AU, :AT, :AZ, :BS, :BH, :BD, :BB, :BY, :BE, :BZ, :BJ, :BM, :BT, :BO, :BA, :BW, :BV, :BR, :IO, :BN, :BG, :BF, :BI, :KH, :CM, :CA, :CV, :KY, :CF, :TD, :CL, :CN, :CX, :CC, :CO, :KM, :CG, :CD, :CK, :CR, :CI, :HR, :CU, :CY, :CZ, :DK, :DJ, :DM, :DO, :EC, :EG, :SV, :GQ, :ER, :EE, :ET, :FK, :FO, :FJ, :FI, :FR, :GF, :PF, :TF, :GA, :GM, :GE, :DE, :GH, :GI, :GR, :GL, :GD, :GP, :GU, :GT, :GG, :GN, :GW, :GY, :HT, :HM, :VA, :HN, :HK, :HU, :IS, :IN, :ID, :IR, :IQ, :IE, :IM, :IL, :IT, :JM, :JP, :JE, :JO, :KZ, :KE, :KI, :KP, :KR, :KW, :KG, :LA, :LV, :LB, :LS, :LR, :LY, :LI, :LT, :LU, :MO, :MK, :MG, :MW, :MY, :MV, :ML, :MT, :MH, :MQ, :MR, :MU, :YT, :MX, :FM, :MD, :MC, :MN, :ME, :MS, :MA, :MZ, :MM, :NA, :NR, :NP, :NL, :AN, :NC, :NZ, :NI, :NE, :NG, :NU, :NF, :MP, :NO, :OM, :PK, :PW, :PS, :PA, :PG, :PY, :PE, :PH, :PN, :PL, :PT, :PR, :QA, :RE, :RO, :RU, :RW, :BL, :SH, :KN, :LC, :MF, :PM, :VC, :WS, :SM, :ST, :SA, :SN, :RS, :SC, :SL, :SG, :SK, :SI, :SB, :SO, :ZA, :GS, :ES, :LK, :SD, :SR, :SJ, :SZ, :SE, :CH, :SY, :TW, :TJ, :TZ, :TH, :TL, :TG, :TK, :TO, :TT, :TN, :TR, :TM, :TC, :TV, :UG, :UA, :AE, :GB, :US, :UM, :UY, :UZ, :VU, :VE, :VN, :VG, :VI, :WF, :EH, :YE, :ZM, :ZW ]
    STATE_ABBREVIATIONS = [ :AL, :AK, :AZ, :AR, :CA, :CO, :CT, :DE, :DC, :FL, :GA, :HI, :ID, :IL, :IN, :IA, :KS, :KY, :LA, :ME, :MD, :MA, :MI, :MN, :MS, :MO, :MT, :NE, :NV, :NH, :NJ, :NM, :NY, :NC, :ND, :OH, :OK, :OR, :PA, :RI, :SC, :SD, :TN, :TX, :UT, :VT, :VA, :WA, :WV, :WI, :WY ]

    attr_accessor :geographical_area, :default_color, :gradient

    data_type :numeric

    def initialize(options={})
      @chart_type = 't'
      @show_legend = false
      @default_color = 'FFFFFF'
      super(options)
    end


    # Called to add map-specific parameters to the query_params hash.
    def add_map_parameters
      @params[:chtm] = geographical_area.to_s
      @params[:chld] = @region_codes.join('') unless @region_codes.empty?
      unless @default_color.empty?
        @params[:chco] = @params[:chco].empty? ? @default_color : "#{@default_color},#{@params[:chco]}"
      end
    end


    #
    # ACCESSORS.
    #
    def data(code, data)
      raise ArgumentError.new("data should be an integer value") unless data.is_a?(Numeric)
      @data << data
      region_code(code)
    end

    def geographical_area=(area)
      raise ArgumentError.new("area must be one of :#{GEOGRAPHICAL_AREAS.join(', :')}") unless GEOGRAPHICAL_AREAS.include?(area)
      @geographical_area = area
    end

    def gradient=(gradient_colors)
      if gradient_colors.is_a?(Array)
        gradient_colors.each { |gradient_color| color(gradient_color) }
      elsif gradient_colors.is_a?(String)
        color(gradient_colors)
      else
        raise ArgumentError.new("gradient must be a single RGB value as a String or an Array of String RGB values")
      end
    end

    private
    def region_code(code)
      @region_codes ||= []

      # Ensure a proper region code is being added.
      raise ArgumentError.new("geographical area must be defined before adding data") unless @geographical_area

      if @geographical_area == :usa
        raise ArgumentError.new("geographical area must be a US state abbreviation") unless STATE_ABBREVIATIONS.include?(code)
      else
        raise ArgumentError.new("geographical area must be an ISO-3166-1 alpha-2 code") unless ISO_3166_1_ALPHA_2.include?(code)
      end

      @region_codes << code
    end

  end
end
