# noinspection RubyUnusedLocalVariable
class Checkout

  STOCK_PRICES = { A: 50, B: 30, C: 20, D: 15, E: 40 }
  SPECIALS_QUANTS = { A: 5, A: 3, B: 2 }
  SPECIALS_PRICES = { A: 200, A: 130, B: 45 }

  def checkout(skus)
    return -1 if check_skus(skus) == false
    @running_total = 0
    sum(update_order_for_specials(summarise_order(skus)), STOCK_PRICES)
    sum(@specials_summary, SPECIALS_PRICES)
    @running_total
  end

  # private

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

  def update_order_for_specials(order_summary)
    @specials_summary = {}
    bogof_remainder(order_summary)
    order_summary.each do |item, quantity|
p 'item...'
p item
      add_items_on_special(@specials_summary, item, quantity, SPECIALS_PRICES)
      specials_remainder(order_summary, item, quantity)
    end
    order_summary
  end

  def sum(order_summary, price_list)
    order_summary.each do |item, quantity|
p 'quantity item...'
      @running_total += order_summary[item] * price_list[item] if price_list.key?(item)
p 'running total...'
p @running_total
    end
  end

  def bogof_remainder(order_summary)
    if order_summary.key?(:B) && order_summary.key?(:E)
      order_summary[:B] -= order_summary[:E] / 2
    end
  end

  def add_items_on_special(specials_summary, item, quantity, price_list)
    item_quantity = quantity / SPECIALS_QUANTS[item] if price_list.key?(item)
    specials_summary[item] = item_quantity unless item_quantity == 0 || item_quantity.nil?
p 'specials summary...'
p specials_summary
  end

  def specials_remainder(order_summary, item, quantity)
# here would need to go round twice with both specials lists
    remainder = quantity % SPECIALS_QUANTS[item] if SPECIALS_PRICES.key?(item)
p 'remainder...'
p remainder
    order_summary[item] = remainder unless remainder.nil?
  end
end
