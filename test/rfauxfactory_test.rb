require "test_helper"
require "set"

class RFauxFactoryTest < Minitest::Test
  GENERATORS = %i[
    gen_html
    gen_alpha
    gen_alphanumeric
    gen_cjk
    gen_cyrillic
    gen_latin1
    gen_numeric_string
    gen_utf8
    gen_special
  ].freeze

  STRING_TYPES = %i[
    html
    alpha
    alphanumeric
    cjk
    cyrillic
    latin1
    numeric
    utf8
    punctuation
  ].freeze
  HTML_TAG_MAX_LENGTH = 2 * RFauxFactory::HTML_TAGS.map(&:length).max + 5 # '<></>'.length == 5
  HTML_TAG_MIN_LENGTH = 2 * RFauxFactory::HTML_TAGS.map(&:length).min + 5 # '<></>'.length == 5
  def test_has_a_version_number
    refute_nil ::RFauxFactory::VERSION
  end

  def assert_letters_ranges(ranges = [])
    assert !ranges.empty?
    last_max_range = 0
    ranges.each do |codepoint_range|
      codepoint_range.is_a?(Range)
      assert codepoint_range.max >= codepoint_range.min
      assert codepoint_range.min > last_max_range
      last_max_range = codepoint_range.max
    end
  end

  def test_latin1_letters_ranges
    assert_letters_ranges RFauxFactory::LATIN_LETTERS_RANGES
  end

  def test_unicode_letters_ranges
    assert_letters_ranges RFauxFactory::UNICODE_LETTERS_RANGES
  end

  # Default string generated is longer than zero characters.
  def test_default_string
    GENERATORS.each do |func_name|
      refute RFauxFactory.send(func_name).empty?
    end
  end

  # String generated has correct length of characters.
  def test_fixed_length
    GENERATORS[1..-1].each do |func_name|
      assert_equal RFauxFactory.send(func_name, 10).length, 10
    end
  end

  # Cannot generate string with alpha length of characters.
  def test_string_alpha_length
    GENERATORS.each do |func_name|
      assert_raises TypeError do
        RFauxFactory.send(func_name, 'a')
      end
    end
  end

  # Cannot generate string with alphanumeric length of characters.
  def test_string_alpha_numeric_length
    GENERATORS.each do |func_name|
      assert_raises TypeError do
        RFauxFactory.send(func_name, '1')
      end
    end
  end

  # Cannot generate string with space length of characters.
  def test_string_space_length
    GENERATORS.each do |func_name|
      assert_raises TypeError do
        RFauxFactory.send(func_name, ' ')
      end
    end
  end

  # Cannot generate string with empty length of characters.
  def test_string_empty_length
    GENERATORS.each do |func_name|
      assert_raises TypeError do
        RFauxFactory.send(func_name, '')
      end
    end
  end

  # Cannot generate string with zero length of characters.
  def test_string_zero_length
    GENERATORS.each do |func_name|
      assert_raises ArgumentError do
        RFauxFactory.send(func_name, 0)
      end
    end
  end

  # Cannot generate string with negative length of characters.
  def test_string_negative_length
    GENERATORS.each do |func_name|
      assert_raises ArgumentError do
        RFauxFactory.send(func_name, -1)
      end
    end
  end

  # Use `gen_string` to generate supported string.
  def test_gen_string
    STRING_TYPES.each do |str_type|
      refute RFauxFactory.gen_string(str_type).empty?
    end
  end

  # Use `gen_string` to generate supported string with expected length.
  def test_gen_string_fixed_length
    STRING_TYPES[1..-1].each do |str_type|
      assert_equal RFauxFactory.gen_string(str_type, 5).length, 5
    end
  end

  # use 'gen_strings' to generate a hash of supported strings types
  def test_gen_strings
    gs = RFauxFactory.gen_strings
    assert_equal STRING_TYPES.to_set, gs.keys.to_set
    gs.each_value do |value|
      assert value.length >= 3
    end
  end

  # use 'gen_strings' to generate a fixed length strings.
  def test_gen_strings_fixed_length
    RFauxFactory.gen_strings(40).each do |str_type, value|
      if str_type == :html
        # html is an exception as tags added
        assert value.length > 40
      else
        assert_equal value.length, 40
      end
    end
  end

  # use 'gen_strings' to generate supported strings with exclude some string types.
  def test_gen_strings_exclude
    exclude_types = %i[html cjk]
    gs = RFauxFactory.gen_strings(exclude: exclude_types)
    assert_equal gs.keys.to_set.intersection(exclude_types.to_set), Set.new
    gs.each_value do |value|
      assert value.length >= 3 && value.length <= 30
    end
  end

  # use 'gen_strings' to generate supported strings with length as an Integer range.
  def test_gen_strings_with_min_max_length
    length = (10..100)
    RFauxFactory.gen_strings(length).each do |str_type, value|
      min_length = length.min
      max_length = length.max
      if str_type == :html
        # html is an exception as tags added
        min_length += HTML_TAG_MIN_LENGTH
        max_length += HTML_TAG_MAX_LENGTH
      end
      assert value.length >= min_length && value.length <= max_length
    end
  end

  # Cannot generate strings with length not integer
  def test_gen_strings_length_type
    ['', ' ', 'a'].each do |length|
      assert_raises TypeError do
        RFauxFactory.gen_strings(length)
      end
    end
  end

  # Cannot generate strings with negative length of characters.
  def test_gen_strings_negative_length
    assert_raises ArgumentError do
      RFauxFactory.gen_strings(-1)
    end
  end

  # Cannot generate strings with zero length of characters.
  def test_gen_strings_zero_length
    assert_raises ArgumentError do
      RFauxFactory.gen_strings(0)
    end
  end

  # Should not be able to generate strings with a bad length range
  def test_gen_strings_bad_length_range
    ['', ' ', 'a'].each do |name|
      assert_raises ArgumentError do
        RFauxFactory.gen_strings(name..name)
      end
    end
    assert_raises ArgumentError do
      RFauxFactory.gen_strings(30..3)
    end
    assert_raises ArgumentError do
      RFauxFactory.gen_strings(-1..10)
    end
    assert_raises ArgumentError do
      RFauxFactory.gen_strings(-10..-1)
    end
    assert_raises ArgumentError do
      RFauxFactory.gen_strings(0..10)
    end
  end

  # Should be able to generate strings with excluding all types without error
  def test_gen_strings_exclude_all
    assert RFauxFactory.gen_strings(exclude: STRING_TYPES).empty?
  end

  # Generate strings with bad exclude type
  def test_gen_strings_bad_exclude_type
    assert_raises TypeError do
      RFauxFactory.gen_strings(exclude: 'string as exclude')
    end
  end

  # Create a random boolean value.
  def test_gen_boolean
    10.times do
      assert [true, false].include? RFauxFactory.gen_boolean
    end
  end
end
