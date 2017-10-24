class Alphabet
  attr_accessor :symbols, :symbols_amount_array

  def initialize
    @symbols = []
    @symbols_amount_array = []
  end

  def add_to_alphabet(array_of_symbols)
    array_of_symbols.each { |s| symbols << s }
  end

  def initialize_symbols_amount
    symbols.each_with_index do |char, index|
      symbols_amount_array[index] = { "#{char}" => 0.0 }
    end
  end
end
