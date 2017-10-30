require_relative "alphabet.rb"
require_relative "probability.rb"
require_relative "text_info.rb"
require_relative "encoder.rb"
require "matrix.rb"

class Matrix
  def []=(row, col, x)
    @rows[row][col] = x
  end
end

class String
  attr_accessor :bytes
end

def russian_alphabet
  russian_alphabet = Alphabet.new
  russian_alphabet.add_to_alphabet(('А'..'я').to_a)
  russian_alphabet.add_to_alphabet(('0'..'9').to_a)
  russian_alphabet.add_to_alphabet(['.', '?', ',', '!', ':', ';', ' ', '"', ")",
   "(", ">", "<", "@", "*", "%", "#", "[", "]", "\n"].to_a)
  russian_alphabet
end

def write_to_file(heading, text)
  open('file.txt', 'a') { |f|
    f << "\n#{heading}\n\n"
    text.each do |element|
      f << "#{element}\n"
    end
  }
end

def write_matrix_to_file(heading, text)
  open('file.txt', 'a') { |f|
    f << "\n#{heading}\n\n"
    for i in 0...text.row_count
      text.row(i).each do |e|
        f << "#{e} "
      end
      f << "\n"
    end
  }
end

def write_shortened_version(heading, amount, size, encoded_size)
  open('shortened_file.txt', 'a'){|f|
    f << "\n#{heading}\nКоличество букв: #{amount}\nРазмер: #{size}\nСжатый размер: #{encoded_size}\n\n"
  }
end

def letters_amount(alphabet, text)
end

R_A = russian_alphabet

def prepare_text_info(text)
  text.count_two_dependant_letters
  text.prepare_chars_info
  text.count_two_dependant_letters
end

def prepare_probability(text_p)
  text_p.count_probability
  text_p.count_two_dependant_letters_probability
end

def prepare_shenon_encode(proba, symbol_length, source)
  text_code = Encoder.new()
  sorted_p = Hash[ proba.sort_by{ |k, v| v }.reverse ]
  text_code.encode(sorted_p, 1.0)
  write_to_file("ДЕРЕВО КОДИРОВАНИЯ #{symbol_length}:", text_code.encode_hash)
  text_code.get_encoded_letters(symbol_length)
  write_to_file("КОДИРОВАНИЕ АЛФАВИТА #{symbol_length}:", text_code.encoded_letters)
  text_code.encode_text(source, "shenon_#{symbol_length}_encode.cake", symbol_length)
  text_code.decode_text("shenon_1_encode.cake", "ПреступлениеИНаказание_decoded.txt") if symbol_length == 1
end

def run(source)
  R_A.initialize_symbols_amount

  text = TextInfo.new(source, R_A)
  prepare_text_info(text)
  open('file.txt', 'a') { |f| f << "\n\n#{source}\n\n" }
  open('file.txt', 'a') { |f| f << "\n\nВСЕГО БУКВ: #{text.char_count}\n\n" }

  text_p = Probability.new(text)
  prepare_probability(text_p)
  # write_to_file("ВЕРОЯТНОСТЬ ДЛЯ 1 БУКВЫ:", text_p.one_letter_p)

  prepare_shenon_encode(text_p.one_letter_p, 1, source)
  prepare_shenon_encode(text_p.two_letters_p, 2, source)
end

run ("ПреступлениеИНаказание.txt")
