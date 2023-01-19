require './lib/products_list.rb'

puts " Welcome to the Torc Take Home project by Javier Botero ".center(80, '*')
puts "\n\nPlease input a listing of products in the next format:"
puts "'1 imported bottle of perfume at 27.99'"
puts "When you are done just write 'exit'\n\n"

list_array = []

loop do
  input = gets.chomp
  break if input.match(/[Ee]xit/)

  list_array << input
end

list = ProductsList.new(list_array)

puts "The receipt:\n"
puts list, "\n\n"
