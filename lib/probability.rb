require "pry-rails"
class Probability
  attr_accessor :text_info, :one_letter_p, :two_letters, :two_letters_p,
  :three_letters, :three_letters_p

  def initialize(text_info)
    @text_info = text_info
    @char_count = text_info.char_count
    @one_letter_p = {}
    @two_letters = text_info.two_letters
    @two_letters_p = {}
    @three_letters = text_info.three_letters
    @three_letters_p = {}
    @alphabet = text_info.alphabet
  end

  def count_probability
    symbols_amount = text_info.symbols_amount_array
    char_count = text_info.char_count
    File.open(text_info.file, "r") do |file|
      file.each_char do |c|
        one_letter_p[c] = symbols_amount[@alphabet.index(c)][c] / char_count if @alphabet.include?(c)
      end
    end
  end

  def count_two_dependant_letters_probability
    @two_letters.keys.each{ |key| @two_letters_p[key] = @two_letters[key]/@char_count }
    @two_letters_p
  end

  def count_three_dependant_letters_probability
    @three_letters.keys.each{ |key| @three_letters_p[key] = @three_letters[key]/@char_count }
    @three_letters_p
  end
end
