class Card
  attr_accessor  :number, :suit, :special_card_name, :points
  
  def initialize(number, suit, special_card_name, points)
    @number = number
    @suit = suit
    @special_card_name = special_card_name
    @points = points || 0
  end
  
  def is_special?
    return false if special_card_name == nil
    true
  end
  
  def to_s()
    if is_special?
      special_card_name
    else
      number.to_s + ":" + suit
    end
  end
  
end

#card1 = Card.new(nil , nil, "ROOK", 20)
