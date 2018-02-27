require "test_helper"

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

  def test_has_a_version_number
    refute_nil ::RFauxFactory::VERSION
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

end
