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
    assert_equal 5, Checkout::SPECIALS_QUANTS[:A], 'Check specials list'
    assert_equal 200, Checkout::SPECIALS_PRICES[:A], 'Check specials list'
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

  def test_calc_E_bogof
p 'test_calc_E_bogof'
    skus = 'EBACCA'
    assert_equal 210, Checkout.new.checkout(skus), 'Calcs discount of free B with 2 Es'
  end

  def test_calc_E_bogof_2
p 'test_calc_E_bogof_2'
    skus = 'EEB'
    assert_equal 80, Checkout.new.checkout(skus), 'Calcs discount of free B with 2 Es'
  end

  def test_calc_E_bogof_3
p 'test_calc_E_bogof_3'
    skus = 'EE'
    assert_equal 80, Checkout.new.checkout(skus), 'Calcs discount of free B with 2 Es'
  end

  def test_calc_A_discount
p 'test_calc_A_discount'
    skus = 'AAAAAAAAA'
    assert_equal 380, Checkout.new.checkout(skus), 'Calcs all 3 levels of A prices'
  end

  def test_calc_A_and_E_bogof
p 'test_calc_A_and_E_bogof'
    skus = 'AAAAAAAAAEEEB'
    assert_equal 500, Checkout.new.checkout(skus), 'Calcs all 3 levels of A prices and E bogof'
  end

  def test_calc_F_discount
p 'test_calc_F_discount'
    skus = 'FFFFFFF'
    assert_equal 50, Checkout.new.checkout(skus), 'Buy 2 Fs, get one free'
  end

  def test_lots_of_discounts
p 'test_lots_of_discounts'
    skus = 'VVVVVQRRRNNN'
    assert_equal 490, Checkout.new.checkout(skus), 'Lots of random discounts'
  end

  def test_U_discounts
p 'test_U_discounts'
    skus = 'UUU'
    assert_equal 120, Checkout.new.checkout(skus), 'U discounts'
  end

  def test_group_discount
p 'test_group_discount'
    skus = 'XXX'
    assert_equal 45, Checkout.new.checkout(skus), 'test group discount'
  end

  def test_group_discount_2
p 'test_group_discount_2'
    skus = 'XXYZ'
    assert_equal 62, Checkout.new.checkout(skus), 'test group discount'
  end

  def test_group_discount_3
p 'test_group_discount_3'
    skus = 'ZZZSSSYYYYX'
    assert_equal 172, Checkout.new.checkout(skus), 'test group discount where X and Y are charged'
  end
end
