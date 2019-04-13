# noinspection RubyResolve,RubyResolve
require_relative '../test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

require_solution 'CHK'

class ClientTest < Minitest::Test

  def test_stock_list
    assert_equal 50, Checkout::STOCK_PRICES[:A], 'Check stock list'
    assert_equal 40, Checkout::STOCK_PRICES[:E], 'Check stock list'
  end

  def test_specials_list
    assert_equal 3, Checkout::SPECIALS_QUANTS[:A], 'Check specials list'
    assert_equal 130, Checkout::SPECIALS_PRICES[:A], 'Check specials list'
  end

  def test_calc_total
p 'test_calc_total'
    skus = 'AAAABBBCCD'
    assert_equal 310, Checkout.new.checkout(skus), 'Calcs total for big order'
  end

  def test_erenous_input
    skus = 'AAaABBBCCD'
    assert_equal -1, Checkout.new.checkout(skus), 'Calcs total for big order'
  end

  def test_calc_E_discount
p 'test_calc_E_discount'
    skus = 'EBACCA'
    assert_equal 210, Checkout.new.checkout(skus), 'Calcs discount of free B with 2 Es'
  end

  def test_calc_E_discount_2
p 'test_calc_E_discount_2'
    skus = 'EEB'
    assert_equal 80, Checkout.new.checkout(skus), 'Calcs discount of free B with 2 Es'
  end

  def test_calc_E_discount_3
p 'test_calc_E_discount_3'
    skus = 'EE'
    assert_equal 80, Checkout.new.checkout(skus), 'Calcs discount of free B with 2 Es'
  end

  def test_calc_A_discount
p 'test_calc_A_discount'
    skus = 'AAAAAAAAA'
    assert_equal 380, Checkout.new.checkout(skus), 'Calcs all 3 levels of A prices'
  end
end
