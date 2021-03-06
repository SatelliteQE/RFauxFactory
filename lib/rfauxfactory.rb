# frozen_string_literal: true

require 'rfauxfactory/version'
require 'rfauxfactory/constants'

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

    def positive_int!(length, name: 'length')
      raise TypeError, "#{name} is not of type Integer" unless length.is_a?(Integer)
      raise ArgumentError, "#{name} must be a positive integer" unless length > 0
    end

    def positive_int_or_range!(length)
      raise TypeError, 'length must be Integer or Range' unless length.is_a?(Integer) || length.is_a?(Range)
      if length.is_a?(Integer)
        positive_int! length
      else
        raise ArgumentError, 'Bad length range' if length.size.nil? || length.size.zero?
        positive_int! length.first, name: 'length.first'
        positive_int! length.last, name: 'length.last'
      end
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
    def gen_strings(length = 10, exclude: [])
      positive_int_or_range! length
      raise TypeError, 'exclude must be an Array' unless exclude.is_a?(Array)
      str_types = RFauxFactory::STRING_TYPES.keys.reject { |str_type| exclude.include?(str_type) }
      str_types.map do |str_type|
        str_length = length.is_a?(Range) ? rand(length) : length
        [str_type, gen_string(str_type, str_length)]
      end.to_h
    end

    # Return a random Boolean value.
    def gen_boolean
      [true, false].sample
    end

    # Generates a random IP address.
    def gen_ipaddr(protocol: :ip4, prefix: [])
      raise ArgumentError, "#{protocol} is not valid protocol" unless IP_BLOCKS.key?(protocol)
      sections = IP_BLOCKS[protocol]
      prefix.map(&:to_s).compact
      sections -= prefix.length
      raise ArgumentError, "Prefix #{prefix} is too long for this configuration" if sections <= 0
      random_fields = if protocol == :ipv6
                        Array.new(sections) { rand(0..2**16 - 1).to_s(16) }
                      else
                        Array.new(sections) { rand(0..255) }
                      end
      ipaddr = (prefix + random_fields).join(IP_SEPARATOR[protocol])
      ipaddr += '.0' if protocol == :ip3
      ipaddr
    end

    # Generates a random MAC address.
    def gen_mac(delimiter: ':', multicast: nil, locally: nil)
      raise ArgumentError, "#{delimiter} is not valid delimiter" unless %w[: -].include?(delimiter)
      multicast = gen_boolean if multicast.nil?
      locally = gen_boolean if locally.nil?
      first_octet = rand(0..255)
      multicast ? first_octet |= 0b00000001 : first_octet &= 0b11111110
      locally ? first_octet |= 0b00000010 : first_octet &= 0b11111101
      octets = [first_octet]
      octets += (Array.new(5) { rand(0..255) })
      octets.map { |octet| format('%02x', octet) }.join(delimiter)
    end

    # Generates a random netmask.
    def gen_netmask(min_cidr: 1, max_cidr: 31)
      raise ArgumentError, "min_cidr must be 0 or greater, but is #{min_cidr}" if min_cidr < 0
      raise ArgumentError, "max_cidr must be 0 or greater, but is #{max_cidr}" if max_cidr >= VALID_NETMASKS.length
      VALID_NETMASKS[rand(min_cidr..max_cidr)]
    end
  end
end
