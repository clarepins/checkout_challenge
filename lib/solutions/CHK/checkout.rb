# noinspection RubyUnusedLocalVariable
class Checkout

  STOCK_PRICES = { A: 50, B: 30, C: 20, D: 15, E: 40 }
  SPECIALS_QUANTS = { A: 5, B: 2 }
  SPECIALS_PRICES = { A: 200, B: 45 }
  SPECIALS_QUANTS_2 = { A: 3 }
  SPECIALS_PRICES_2 = { A: 130 }

  def checkout(skus)
    return -1 if check_skus(skus) == false
    @running_total = 0
    order_summary = summarise_order(skus)
    specials_summary = {}
    specials_summary_2 = {}
    remove_items_on_bogof(order_summary)
    update_order_for_specials(order_summary, specials_summary, SPECIALS_QUANTS)
    update_order_for_specials(order_summary, specials_summary_2, SPECIALS_QUANTS_2)
    sum(order_summary, STOCK_PRICES)
    sum(specials_summary, SPECIALS_PRICES)
    sum(specials_summary_2, SPECIALS_PRICES_2)
    @running_total
  end

  private

  def check_skus(skus)
    skus.each_char do |item_string|
      return false unless STOCK_PRICES.key?(item_string.to_sym)
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

  def update_order_for_specials(order_summary, specials_summary, quant_list)
    order_summary.each do |item, quantity|
      add_items_on_special(specials_summary, item, quantity, quant_list)
      remove_items_on_special(order_summary, item, quantity, quant_list)
    end
    order_summary
  end

  def sum(order_summary, price_list)
    order_summary.each do |item, quantity|
      @running_total += order_summary[item] * price_list[item]
    end
  end

  def remove_items_on_bogof(order_summary)
    if order_summary.key?(:B) && order_summary.key?(:E)
      order_summary[:B] -= order_summary[:E] / 2
    end
  end

  def add_items_on_special(specials_summary, item, quantity, quant_list)
    item_quantity = quantity / quant_list[item] if quant_list.key?(item)
    specials_summary[item] = item_quantity unless item_quantity == 0 || item_quantity.nil?
  end

  def remove_items_on_special(order_summary, item, quantity, quant_list)
    remainder = quantity % quant_list[item] if quant_list.key?(item)
    order_summary[item] = remainder unless remainder.nil?
  end
end
