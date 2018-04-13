# frozen_string_literal: true

require 'test_helper'

class RFauxFactoryNetTest < Minitest::Test
  PROTOCOL_TYPES = { ip3: 4, ip4: 4, ipv6: 8 }.freeze
  PROTOCOL_SEPARATOR = { ip3: '.', ip4: '.', ipv6: ':' }.freeze
  NETMASK_REGEX = '((255.){3}(0|128|192|224|240|248|252|254|255))|((255.){2}(0|128|192|224|240|248|252|254).0)|' \
                  '(255.(0|128|192|224|240|248|252|254)(.0){2})|((0|128|192|224|240|248|252|254)(.0){3})'
  # Cannot generate ipaddr of invalid protocol
  def test_gen_ipaddr_invalid_protocol
    assert_raises ArgumentError do
      RFauxFactory.gen_ipaddr(protocol: :ip5)
    end
  end

  # Cannot generate ipaddr with long prefix
  def test_gen_ipaddr_long_prefix
    assert_raises ArgumentError do
      RFauxFactory.gen_ipaddr(protocol: :ip4, prefix: [10, 11, 12, 13])
    end
  end

  # Check generate ipaddr without prefix
  def test_gen_ipaddr_without_prefix
    PROTOCOL_TYPES.keys.each do |protocol|
      assert_equal RFauxFactory.gen_ipaddr(protocol: protocol).split(PROTOCOL_SEPARATOR[protocol]).length,
                   PROTOCOL_TYPES[protocol]
    end
  end

  # Check generate ipaddr without prefix
  def test_gen_ipaddr_with_prefix
    PROTOCOL_TYPES.keys.each do |protocol|
      ipaddr = RFauxFactory.gen_ipaddr(protocol: protocol, prefix: [10, 11])
      assert ipaddr.split(PROTOCOL_SEPARATOR[protocol]).length, PROTOCOL_TYPES[protocol]
      assert_includes ipaddr.split(PROTOCOL_SEPARATOR[protocol]), '10'
    end
  end

  # Check that ip3 ends with 0
  def test_gen_ipaddr_ip3_ending
    assert_equal RFauxFactory.gen_ipaddr(protocol: :ip3).split('.')[-1], '0'
  end

  # Generate MAC address
  def test_gen_mac
    mac = RFauxFactory.gen_mac
    assert_equal mac =~ /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/, 0
    assert_equal mac.split(':').length, 6
  end

  # Generate a multicast and globally unique MAC address
  def test_gen_mac_unicast_globally_unique
    mac = RFauxFactory.gen_mac(multicast: false, locally: false)
    first_octect = mac.split(':')[0].to_i(16)
    mask = 0b00000011
    assert_equal first_octect & mask, 0
  end

  # Generate a unicast and locally administered MAC address
  def test_gen_mac_multicast_globally_unique
    mac = RFauxFactory.gen_mac(multicast: true, locally: false)
    first_octect = mac.split(':')[0].to_i(16)
    mask = 0b00000011
    assert_equal first_octect & mask, 1
  end

  # Generate a unicast and locally administered MAC address
  def test_gen_mac_unicast_locally_administered
    mac = RFauxFactory.gen_mac(multicast: false, locally: true)
    first_octect = mac.split(':')[0].to_i(16)
    mask = 0b00000011
    assert_equal first_octect & mask, 2
  end

  # Generate a multicast and locally administered MAC address
  def test_gen_mac_multicast_locally_administered
    mac = RFauxFactory.gen_mac(multicast: true, locally: true)
    first_octect = mac.split(':')[0].to_i(16)
    mask = 0b00000011
    assert_equal first_octect & mask, 3
  end

  # Cannot generate mac with wrong delimiter
  def test_gen_mac_wrong_delimiter
    assert_raises ArgumentError do
      RFauxFactory.gen_mac(delimiter: RFauxFactory.gen_alpha(1))
    end
  end

  # Generate netmask
  def test_gen_netmask
    netmask = RFauxFactory.gen_netmask
    assert_equal netmask.split('.').length, 4
    assert_equal netmask =~ Regexp.new(NETMASK_REGEX), 0
  end

  def test_valid_netmasks
    RFauxFactory::VALID_NETMASKS.each do |netmask|
      assert_equal netmask =~ Regexp.new(NETMASK_REGEX), 0
    end
  end

  def test_gen_netmask_boundary
    assert_equal '0.0.0.0', RFauxFactory.gen_netmask(min_cidr: 0, max_cidr: 0)
    assert_equal '255.255.255.255', RFauxFactory.gen_netmask(min_cidr: 32, max_cidr: 32)
    assert_raises ArgumentError do
      RFauxFactory.gen_netmask(min_cidr: -1, max_cidr: 16)
    end
    assert_raises ArgumentError do
      RFauxFactory.gen_netmask(min_cidr: 16, max_cidr: 33)
    end
  end
end
