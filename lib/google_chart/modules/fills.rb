require 'ostruct'
module GoogleChart
  # This module is used as a mixin for providing solid, linear gradient and stripe fills
  module Fills
    FILL_KINDS = [:solid, :gradient, :stripes]

    FILL_TYPES_SOLID = [:background, :chart, :transparent]
    FILL_TYPES       = [:background, :chart]
    FILL_TYPE_CODES  = ["bg", "c", "a"]

    SolidFill    = Struct.new("SolidFill", :type, :color)
    GradientFill = Struct.new("GradientFill", :type, :angle, :colors, :offsets)
    StripesFill  = Struct.new("StripesFill", :type, :angle, :colors, :widths)

    # TODO add proper docs
    def fill(type, options = {})
      @fills ||= []
      raise ArgumentError.new("Invalid fill type") unless FILL_KINDS.include?(type)
      f= create_fill(type)


      f.type = :background #default
      options.each { |k,v| f.send("#{k}=",v)}

      yield f if block_given?

      validate_fill(f)

      @fills << parse_fill(f)
    end

    private
    def add_fills
      @params[:chf] = @fills.join("|") unless @fills.empty?
    end

    def create_fill(type)
      case type
      when :solid
        SolidFill.new
      when :gradient
        GradientFill.new
      when :stripes
        StripesFill.new
      end
    end

    def validate_fill(f)
      case f
      when SolidFill
        validate_solid(f)
      when GradientFill
        validate_gradient(f)
      when StripesFill
        validate_stripes(f)
      end
    end

    def validate_solid(f)
      raise ArgumentError.new("Invalid fill type value. Must be one of :background, :chart or :transparent") unless FILL_TYPES_SOLID.include?(f.type)
      raise ArgumentError.new(":color must be a string value") unless f.color.is_a?(String)
    end

    def validate_gradient(f)
      raise ArgumentError.new("Invalid fill type value. Must be one of :background, :chart or :transparent") unless FILL_TYPES.include?(f.type)
      raise ArgumentError.new("angle must be a numeric value") unless f.angle.is_a?(Numeric)
      #TODO validate color values using regex
      raise ArgumentError.new(":colors must be an array of strings") unless f.colors.is_a?(Array) and f.colors.all? { |i| i.is_a?(String)}
      raise ArgumentError.new(":offsets must be an array of numeric values between 0 and 1") unless f.offsets.is_a?(Array) and
                                                                                                    f.offsets.is_numeric_array? and
                                                                                                    f.offsets.all? { |i| i>=0 and i<=1 }
    end

    def validate_stripes(f)
      raise ArgumentError.new("Invalid fill type value. Must be one of :background, :chart or :transparent") unless FILL_TYPES.include?(f.type)
      raise ArgumentError.new("angle must be a numeric value") unless f.angle.is_a?(Numeric)
      #TODO validate color values using regex
      raise ArgumentError.new(":colors must be an array of strings") unless f.colors.is_a?(Array) and f.colors.all? { |i| i.is_a?(String)}
      raise ArgumentError.new(":widths must be an array of numeric values between 0 and 1") unless f.widths.is_a?(Array) and
                                                                                                    f.widths.is_numeric_array? and
                                                                                                    f.widths.all? { |i| i>=0 and i<=1 }
    end

    def parse_fill(f)
      case f
      when SolidFill
        "#{map_type(f.type)},s,#{f.color}"
      when GradientFill
        colors_offsets = f.colors.zip(f.offsets).collect { |item| item.join(",") }.join(",")
        "#{map_type(f.type)},lg,#{f.angle},#{colors_offsets}"
      when StripesFill
        colors_widths = f.colors.zip(f.widths).collect { |item| item.join(",") }.join(",")
        "#{map_type(f.type)},ls,#{f.angle},#{colors_widths}"
      end
    end

    def map_type(t)
      i = FILL_TYPES_SOLID.index(t)
      FILL_TYPE_CODES[i]
    end
  end
end
