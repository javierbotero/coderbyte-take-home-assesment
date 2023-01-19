# frozen_string_literal: true

class ProductsList
  attr_accessor :list, :total, :tax

  FOOD = ['chocolate', 'water', 'banana', 'orange', 'chicken', 'vegetable', 'soda']
  MEDICINE = ['pill', 'tablet', 'capsule', 'suppositor', 'injection']
  EDUCATION = ['book']

  def initialize(list_items)
    self.list = {}
    self.total = 0
    self.tax = 0

    populate_list(list_items)
    calculate_total_tax
    calculate_total
  end

  def populate_list(list_items)
    list_items.each do |item|
      description_arr = item.split(' ')
      quantity, imported, name, price = build_properties(description_arr)
      tax_item = calculate_tax(quantity, imported, name, price)
      self.list[name] = {
        quantity: quantity,
        imported: imported,
        price: price,
        tax: tax_item
      }
    end
  end

  def calculate_total_tax
    self.list.each { |key, val| self.tax += val[:tax] }
  end

  def calculate_total
    self.list.each { |key, val| self.total += (val[:price] * val[:quantity]) }
    self.total = self.total.round(4)
    self.total += self.tax
  end

  def build_properties(arr)
    quantity = arr.shift
    second = arr.shift
    imported = second == 'imported' ? true : false
    name = second
    while name.split(' ')[-1] != 'at'
      name << ' ' + arr.shift
    end
    name.gsub!(/ at/, '')
    price = arr.shift
    [quantity.to_i, imported, name, price.to_f]
  end

  def calculate_tax(quantity, imported, name, price)
    total_tax = 0
    total_item = quantity * price

    unless not_taxable(name)
      total_tax = total_item * 0.1
    end

    if imported
      total_tax += total_item * 0.05
    end

    round_number(total_tax)
  end

  def round_number(number)
    (number * 20).round / 20.0
  end

  def not_taxable(name)
    FOOD.any?{ |food| name =~ /#{food}/ } ||
      MEDICINE.any?{ |food| name =~ /#{food}/ } ||
      EDUCATION.any?{ |food| name =~ /#{food}/ }
  end

  def to_s
    output = String.new
    self.list.each do |key, val|
      output << "#{val[:quantity]} #{key}: #{val[:price]}\n"
    end
    output << "Sales Taxes: #{"%.2f" % self.tax}\n"
    output << "Total: #{"%.2f" % self.total}\n"
  end
end
