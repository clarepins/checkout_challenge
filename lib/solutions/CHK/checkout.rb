# noinspection RubyUnusedLocalVariable
class Checkout

  STOCK_PRICES = { A: 50, B: 30, C: 20, D: 15 }
  SPECIALS_QUANTS = { A: 3, B: 2 }
  SPECIALS_PRICES = { A: 130 , B: 45 }

  def checkout(skus)
    return -1 if check_skus(skus) == false
    @running_total = 0
    sum_normals(sum_specials(summarise_order(skus)))
    @running_total
  end

  private

  def check_skus(skus)
    skus.each_char do |item|
      return false unless STOCK_PRICES.key?(item.to_sym)
    end
  end

  def summarise_order(skus)
    order_summary = {}
    items_array = skus.chars.uniq
    items_array.each do |item|
      order_summary[item.to_sym] = skus.count(item)
    end
    order_summary
  end

  def sum_specials(order_summary)
    order_summary.each do |item, quantity|
      calc_remainder(order_summary, item, quantity)
      add_special_items(item, quantity, SPECIALS_PRICES)
    end
    order_summary
  end

  def sum_normals(order_after_specials)
    order_after_specials.each do |item, quantity|
      add_normal_items(order_after_specials, item, quantity, STOCK_PRICES)
    end
  end

  def add_special_items(item, quantity, price_list)
    @running_total += quant_specials(item, quantity) * price_list[item] if price_list.key?(item)
  end

  def add_normal_items(order_after_specials, item, quantity, price_list)
    @running_total += order_after_specials[item] * price_list[item]
  end

  def calc_remainder(order_after_specials, item, quantity)
    remainder = quantity % SPECIALS_QUANTS[item] if SPECIALS_PRICES.key?(item)
    order_after_specials[item] = remainder unless remainder.nil?
  end

  def quant_specials(item, quantity)
    quantity / SPECIALS_QUANTS[item]
  end
end
