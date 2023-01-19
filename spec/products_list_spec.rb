require './lib/products_list.rb'

RSpec.describe ProductsList do
  let(:list1) { ['  2 book at 12.49  ', '1 music CD at 14.99', '1 chocolate bar at 0.85'] }
  let(:list2) { [' 1 imported box of chocolates at 10.00', '1 imported bottle of perfume at 47.50'] }
  let(:list3) { ['1 imported bottle of perfume at 27.99', '1 bottle of perfume at 18.99', '1 packet of headache pills at 9.75', '3 imported boxes of chocolates at 11.25'] }
  let(:created_list1) { ProductsList.new(list1) }
  let(:created_list2) { ProductsList.new(list2) }
  let(:created_list3) { ProductsList.new(list3) }
  let(:to_s_1) do
    output = ''
    created_list1.list.each do |key, val|
      output << "#{val[:quantity]} #{key}: #{val[:price]}\n"
    end
    output << "Sales Taxes: #{created_list1.tax}0\n"
    output << "Total: #{created_list1.total}\n"
  end

  context "#initialize" do
    it 'creates an object with given properties with list1' do
      expect(created_list1.list).to eq ({
        'book' => { quantity: 2, imported: false, price: 12.49, tax: 0.0 },
        'music CD' => { quantity: 1, imported: false, price: 14.99, tax: 1.50 },
        'chocolate bar' => { quantity: 1, imported: false, price: 0.85, tax: 0.0 }
      })
      expect(created_list1.total).to be 42.32
      expect(created_list1.tax).to be 1.50
    end

    it 'creates an object with given properties with list2' do
      expect(created_list2.list).to eq ({
        'imported box of chocolates' => { quantity: 1, imported: true, price: 10.00, tax: 0.5 },
        'imported bottle of perfume' => { quantity: 1, imported: true, price: 47.50, tax: 7.15 }
      })
      expect(created_list2.total).to be 65.15
      expect(created_list2.tax).to be 7.65
    end

    it 'creates an object with given properties with list2' do
      expect(created_list3.list).to eq ({
        'imported bottle of perfume' => { quantity: 1, imported: true, price: 27.99, tax: 4.20 },
        'bottle of perfume' => { quantity: 1, imported: false, price: 18.99, tax: 1.90 },
        'packet of headache pills' => { quantity: 1, imported: false, price: 9.75, tax: 0.0 },
        'imported boxes of chocolates' => { quantity: 3, imported: true, price: 11.25, tax: 1.70 },
      })
      # This two test will fail due to imported boxes of chocolates count would be
      # 11.25 * 3 = 33.75
      # 33.75 * 5% = 1.70 --> rounded to nearest 0.05
      # 33.75 + 1.70 = 35.45
      expect(created_list3.total).to be 98.38
      expect(created_list3.tax).to be 7.90
    end
  end

  context "#to_s" do
    it "Build proper output" do
      expect(created_list1.to_s).to eq to_s_1
    end
  end
end
