# noinspection RubyUnusedLocalVariable
class Checkout

  STOCK_PRICES = {
    A: 50,
    B: 30,
    C: 20,
    D: 15,
    E: 40,
    F: 10,
    G: 20,
    H: 10,
    I: 35,
    J: 60,
    K: 80,
    L: 90,
    M: 15,
    N: 40,
    O: 10,
    P: 50,
    Q: 30,
    R: 50,
    S: 30,
    T: 20,
    U: 40,
    V: 50,
    W: 20,
    X: 90,
    Y: 10,
    Z: 50 }

  SPECIALS_QUANTS = {
    A: 5,
    B: 2,
    F: 3,
    H: 10,
    K: 2,
    P: 5,
    Q: 3,
    U: 4,
    V: 3 }

  SPECIALS_PRICES = {
    A: 200,
    B: 45,
    F: 20,
    H: 80,
    K: 150,
    P: 200,
    Q: 80,
    U: 120,
    V: 130 }

  SPECIALS_QUANTS_2 = {
    A: 3,
    H: 5,
    V: 2 }

  SPECIALS_PRICES_2 = {
    A: 130,
    H: 45,
    V: 90 }

  # BOGOF = {
  #   E: { quant: 2, free: :B },
  #   N: { quant: 3, free: :M },
  #   R: { quant: 3, free: :Q }
  # }

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
    order_summary[:B] -= order_summary[:E] / 2 if order_summary.key?(:B) && order_summary.key?(:E)
    order_summary[:M] -= order_summary[:N] / 3 if order_summary.key?(:M) && order_summary.key?(:N)
    order_summary[:Q] -= order_summary[:R] / 3 if order_summary.key?(:Q) && order_summary.key?(:R)
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
