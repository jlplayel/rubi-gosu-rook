require_relative "Card"

class DeckFactory
  attr_accessor :numbers_a, :suits_a, :jocker_a, :points_h, :cards
  
  def initialize(args)
    @numbers_a = args.fetch(:numbers_a, [1, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14])
    @suits_a = args.fetch(:suits_a, ["RED","YELLOW","BLACK","GREEN"])
    @jocker_a = args.fetch(:jocker_a, ["ROOK"])
    @points_h = args.fetch(:points_h, {5=>5, 10=>10, 14=>10, 1=>15, "ROOK"=>20})
    @cards = make_cards()
  end
  
  def make_cards()
    cards_result = Array.new(numbers_a.length * suits_a.length + jocker_a.length)
    
    counter = 0
    
    suits_a.each { |suit|
        numbers_a.each {
            |number|
                                   #Card.new(number, suit, special_card_name, points)
            cards_result[counter] = Card.new(number, suit, nil, points_h[number])
            counter = counter + 1
        }
    }
    
    jocker_a.each { |jocker|
        cards_result[counter] = Card.new(0 , nil, jocker, points_h[jocker])
        counter = counter + 1
    }
    
    return cards_result
  end
  
  def print_cards()
    puts cards().join(' ')
  end
  
end