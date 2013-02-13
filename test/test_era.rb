# -*- coding: utf-8 -*-

$: << "."

require 'test_helper'
require 'japanese-phone-number/era'

class TestEra < Test::Unit::TestCase
  include JapanesePhoneNumber::Era

  def test_era
    assert_equal(Date.new(1999, 10, 1), era_to_date("平成11年10月1日"))
    assert_raise(ArgumentError) {
      era_to_date("昭和39年10月1日")
    }
  end
end