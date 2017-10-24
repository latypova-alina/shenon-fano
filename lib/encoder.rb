require "pry-rails"
class Encoder
  attr_accessor :probability_one, :encode_hash, :encoded_letters

  def initialize(probability_one)
    @probability_one = probability_one
    @encode_hash = Hash.new{ |hsh, key| hsh[key] = ""}
    @encoded_letters = {}
  end

  def get_encoded_letters
    @encode_hash.keys.each { |k| @encoded_letters[k] = @encode_hash[k] if k.length == 1 }
    @encoded_letters = @encoded_letters.sort.to_h
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
    sum_p = 0.0
    first_block, second_block = {}, {}
    if probability_block.length == 2
      first_block[probability_block.keys[0]] = probability_block.values[0]
      second_block[probability_block.keys[1]] = probability_block.values[1]
      sum_p = current_p/2
    else
      probability_block.each_with_index do |element, i|
        key, value = element[0], element[1]
        sum_p = sum_p + value
        sum_p <= current_p/2 ? (first_block[key] = value) : (second_block[key] = value)
      end
    end
    return first_block, second_block, sum_p
  end

  def encode(probability_block, current_p, previous_key = nil)
    return if probability_block.empty?
    first_block, second_block, current_p = devide(probability_block, current_p)
    encode_block(first_block, current_p/2, "0", previous_key)
    encode_block(second_block, current_p/2, "1", previous_key)
  end
end
