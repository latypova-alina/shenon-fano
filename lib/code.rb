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

def russian_alphabet
  russian_alphabet = Alphabet.new
  russian_alphabet.add_to_alphabet(('А'..'я').to_a)
  russian_alphabet.add_to_alphabet(('0'..'9').to_a)
  russian_alphabet.add_to_alphabet(['.', '?', ',', '!', ':', ';', ' ', '"', ")",
   "(", ">", "<", "@", "*", "%", "#", "[", "]"].to_a)
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

def write_shortened_version(heading, amount, entropia1, entropia2, entropia3)
  open('shortened_file.txt', 'a'){|f|
    f << "\n#{heading}\nКоличество букв: #{amount}\nH1: #{entropia1}\nH2: #{entropia2}\nH3: #{entropia3}\n\n"
  }
end

def letters_amount(alphabet, text)
  text.prepare_chars_info
  text.symbols_amount_array
end

R_A = russian_alphabet

def count(source)
  R_A.initialize_symbols_amount
  text = TextInfo.new(source, R_A)
  write_to_file("КОЛИЧЕСТВО КАЖДОЙ БУКВЫ:", letters_amount(R_A, text))
  open('file.txt', 'a') { |f| f << "\n\nВСЕГО БУКВ: #{text.char_count}\n\n" }
  text_p = Probability.new(text)
  text_p.count_probability
  write_to_file("ВЕРОЯТНОСТЬ ДЛЯ 1 БУКВЫ:", text_p.one_letter_p)
  text_code = Encoder.new(text_p)
  text_code.encode(text_p.one_letter_p, 1.0)
  open('file.txt', 'a') { |f| f << "\n\nКодирование: #{text_code.encode_hash}\n\n" }
end

count("Памятник.txt")
