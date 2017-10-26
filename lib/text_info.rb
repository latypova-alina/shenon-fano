class TextInfo
  attr_accessor :file, :alphabet, :char_count, :symbols_amount_array,
  :two_letters, :three_letters

  def initialize(file, alphabet)
    @file = file
    @alphabet = alphabet.symbols
    @char_count = 0.0
    @symbols_amount_array = alphabet.symbols_amount_array
    @two_letters = {}
    @three_letters = {}
  end

  def prepare_chars_info
    File.open(file, "r") do |file|
      file.each_char do |c|
        if alphabet.include?(c)
          symbols_amount_array[alphabet.index(c)][c] += 1.0
          @char_count += 1.0
        end
      end
    end
  end

  def letters_included_in_alphabet?(letters)
    letters.map{|char| alphabet.include?(char)}.uniq() == [true]
  end

  def count_two_dependant_letters
    File.open(file, "r") do |file|
      file.each_line do |line|
        for i in 0...(line.length - 2)
          two_chars = [line[i], line[i+1]]
          regex = "#{two_chars[0]}#{two_chars[1]}"
          if letters_included_in_alphabet?(two_chars)
            if @two_letters[regex]
              @two_letters[regex] += 1.0
            else
              @two_letters[regex] = 1.0
            end
          end
        end
      end
    end
  end

  def count_three_dependant_letters
    File.open(file, "r") do |file|
      file.each_line do |line|
        for i in 0...(line.length - 2)
          three_chars = [line[i], line[i+1], line[i+2]]
          regex = "#{three_chars[0]}_#{three_chars[1]}_#{three_chars[2]}"
          if letters_included_in_alphabet?(three_chars)
            if @three_letters[regex] && letters_included_in_alphabet?(three_chars)
              @three_letters[regex] += 1.0
            else
              @three_letters[regex] = 1.0
            end
          end
        end
      end
    end
  end
end
