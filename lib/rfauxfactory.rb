require "rfauxfactory/version"
require "rfauxfactory/constants"

# The python FauxFactory port
module RFauxFactory
  STRING_TYPES = {
    alpha: :gen_alpha,
    alphanumeric: :gen_alphanumeric,
    cjk: :gen_cjk,
    cyrillic: :gen_cyrillic,
    html: :gen_html,
    latin1: :gen_latin1,
    numeric: :gen_numeric_string,
    utf8: :gen_utf8,
    punctuation: :gen_special
  }.freeze

  class << self
    private

    def gen_string_from_letters(length, letters)
      max_index = letters.length - 1
      (1..length).map do
        letters[rand(max_index)].chr
      end.join
    end

    def gen_string_from_cp_range(length, max_or_range)
      (1..length).map do
        char_ascii = rand(max_or_range)
        char_ascii.chr(Encoding::UTF_8)
      end.join
    end

    def positive_int!(length)
      raise TypeError, 'length is not of type Integer' unless length.is_a? Integer
      raise ArgumentError, 'length must be a positive integer' if length <= 0
    end

    public

    # Returns a random string made up of alpha characters.
    def gen_alpha(length = 10)
      positive_int! length
      gen_string_from_letters length, ASCII_LETTERS
    end

    # Returns a random string made up of alpha and numeric characters.
    def gen_alphanumeric(length = 10)
      positive_int! length
      gen_string_from_letters length, ALPHANUMERIC
    end

    # Returns a random string made up of CJK characters.
    def gen_cjk(length = 10)
      positive_int! length
      gen_string_from_cp_range length, CJK_LETTERS_RANGE
    end

    def gen_utf8(length = 10)
      positive_int! length
      gen_string_from_letters length, UNICODE_LETTERS
    end

    # Returns a random string made up of UTF-8 characters.
    # (Font: Wikipedia - Latin-1 Supplement Unicode Block)
    def gen_latin1(length = 10)
      positive_int! length
      gen_string_from_letters length, LATIN_LETTERS
    end

    # Returns a random string made up of Cyrillic characters.
    def gen_cyrillic(length = 10)
      positive_int! length
      gen_string_from_cp_range length, CYRILLIC_LETTERS_RANGE
    end

    # Returns a random string made up of numbers.
    def gen_numeric_string(length = 10)
      positive_int! length
      gen_string_from_letters length, DIGITS
    end

    # Returns a random string made up of html characters.
    def gen_html(length = 10)
      positive_int! length
      html_tag = HTML_TAGS.sample
      "<#{html_tag}>#{gen_alpha(length)}</#{html_tag}>"
    end

    def gen_special(length = 10)
      positive_int! length
      gen_string_from_letters length, PUNCTUATION
    end

    # A simple wrapper that calls other string generation methods.
    def gen_string(str_type, length = 10)
      raise ArgumentError, "str_type: #{str_type} not supported" unless RFauxFactory::STRING_TYPES.key?(str_type)
      send(RFauxFactory::STRING_TYPES[str_type], length)
    end

    # Generates a list of different input strings.
    def gen_strings(length = nil, exclude: [], min_length: 3, max_length: 30)
      raise ArgumentError, "exclude must be an Array" unless exclude.is_a?(Array)
      positive_int! min_length
      positive_int! max_length
      raise ArgumentError, "max_length must be greater than min_length" unless max_length > min_length
      RFauxFactory::STRING_TYPES.keys.reject { |str_type| exclude.include?(str_type) }.map do |str_type|
        str_length = length.nil? ? rand((min_length..max_length)) : length
        [str_type, gen_string(str_type, str_length)]
      end.to_h
    end

    # Return a random Boolean value.
    def gen_boolean
      [true, false].sample
    end
  end
end
