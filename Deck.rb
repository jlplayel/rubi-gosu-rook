require_relative "DeckFactory"

class Deck
  def initialize(deck_factory)
    @cards = deck_factory.cards
  end
  
  def next_card()
    @cards.shift
  end
  
  def number_of_cards()
    @cards.length()
  end
  
  def cut()
    @cards = @cards.rotate!(rand(number_of_cards()-1)+1)
    self
  end
  
  def shuffle()
    @cards = @cards.shuffle
    self
  end
  
  
end

#df = DeckFactory.new({})
#deck = Deck.new(df)
#puts deck.number_of_cards()
#puts deck.next_card().to_string()
#puts deck.number_of_cards()
#puts deck.next_card().to_string()
#puts deck.number_of_cards()
#puts deck.next_card().to_string()
#puts deck.number_of_cards()