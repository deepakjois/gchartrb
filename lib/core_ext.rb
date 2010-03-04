class Array
  # Returns true if all elements are numeric
  def is_numeric_array?
    self.all? {|data| data.is_a?(Numeric) }
  end

  # Returns true if all elements are numeric in form [X,Y]
  def is_numeric_2d_array?
    self.all? do |data|
      data.is_a?(Array) &&
      data.size == 2 &&
      data.is_numeric_array?
    end
  end

  # Returns all the X values of an array containing elements of the form [X,Y]
  def x_values
    raise ArgumentError.new("#{self.inspect} is not a 2D numeric array") unless is_numeric_2d_array?
    self.collect { |item| item.first }
  end

  # Returns all the Y values of an array containing elements of the form [X,Y]
  def y_values
    raise ArgumentError.new("#{self.inspect} is not a 2D numeric array") unless is_numeric_2d_array?
    self.collect { |item| item.last }
  end

end

class Numeric
  def is_numeric? ; true ; end
end

class String
  def starts_with?(str)
    str = str.to_str
    head = self[0, str.length]
    head == str
  end
end
