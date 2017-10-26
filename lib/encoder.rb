require "pry-rails"
class Encoder
  attr_accessor :encode_hash, :encoded_letters, :encoded_text_array, :decoded_text

  def initialize
    @encode_hash = Hash.new{ |hsh, key| hsh[key] = ""}
    @encoded_letters = {}
    @encoded_text_array = []
    @decoded_text = ""
  end

  def encode(probability_block, current_p, previous_key = nil)
    return if probability_block.empty?
    first_block, second_block, current_p = devide(probability_block, current_p)
    encode_block(first_block, current_p/2, "0", previous_key)
    encode_block(second_block, current_p/2, "1", previous_key)
  end

  def get_encoded_letters(symbol_length)
    @encode_hash.keys.each { |k| @encoded_letters[k] = @encode_hash[k] if k.length == symbol_length }
    @encoded_letters = @encoded_letters.sort.to_h
  end

  def encode_text(input_file, output_file, symbol_length)
    encode_by_one(input_file, output_file) if symbol_length == 1
    encode_by_two(input_file, output_file) if symbol_length == 2
    create_encoded_file(output_file)
  end

  def decode_text(file)
    bits = File.binread(file).unpack("B*")[0]
    bit = ""
    for i in 0...(bits.length - 1)
      if @encoded_letters.values.include?(bit << bits[i])
        @decoded_text << @encoded_letters.key(bit)
        bit = ""
      end
    end
    @decoded_text
  end

  private

  def encode_by_one(input_file, output_file)
    File.open(input_file, "r") do |file|
      file.each_char do |c|
        @encoded_text_array << @encoded_letters[c] if @encoded_letters[c]
      end
    end
  end

  def encode_by_two(input_file, output_file)
    File.open(input_file, "r") do |file|
      file.each_line do |line|
        for i in 0...(line.length - 2)
          two_chars = [line[i], line[i+1]]
          regex = "#{two_chars[0]}#{two_chars[1]}"
          if @encoded_letters[regex]
            @encoded_text_array << @encoded_letters[regex]
          end
        end
      end
    end
    create_encoded_file(output_file)
  end

  def create_encoded_file(output_file)
    File.open(output_file, 'wb' ) do |output|
      output.write [@encoded_text_array.join].pack("B*")
    end
  end

  def block_to_string(block, string = "")
    block.keys.each {|element| string << "#{element}"}
    string
  end

  def encode_block(probability_block, current_p, code_value, previous_key = nil)
    return if @encode_hash.keys.include?(block_to_string(probability_block))
    key = block_to_string(probability_block)
    previous_key = key if previous_key.nil?
    @encode_hash[key] = @encode_hash[previous_key] + code_value
    previous_key = key
    encode(probability_block, current_p, previous_key)
  end

  def devide(probability_block, current_p)
    p_b = probability_block
    first_block, second_block, sum_p = distribute_probabilities(p_b, current_p/2)
    if uneven_case?(first_block, second_block)
      first_block, second_block, sum_p = distribute_probabilities(p_b, p_b.values.max)
    end
    return first_block, second_block, sum_p
  end

  def distribute_probabilities(probability_block, compare_value)
    sum_p = 0.0
    first_block, second_block = {}, {}
    probability_block.each_with_index do |element, i|
      key, value = element[0], element[1]
      sum_p = sum_p + value
      sum_p <= compare_value ? (first_block[key] = value) : (second_block[key] = value)
    end
    return first_block, second_block, sum_p
  end

  def uneven_case?(block1, block2)
    (block1.empty? && block2.length > 1) || (block2.empty? && block1.length > 1)
  end
end
