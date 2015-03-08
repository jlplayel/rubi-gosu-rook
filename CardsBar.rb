require_relative "CardView"

class CardsBar
  def initialize(window, cards, x, y, min_z)
    @window = window
    @first_x = x
    @first_y = y
    @z = min_z
    @card_views = organize_card_views(cards)
  end
  
  def organize_card_views(cards)
    card_number = cards.length
    card_width = CardView.new(@window, cards[0], 30, 30, 5).width()
    
    bar_width = @window.width - 2*@first_x
    width_leftover = bar_width - card_number*card_width- 2*(card_number-1) #2px between cards
    
    if width_leftover >= 0  #Centering the cards
      @first_x = @first_x + width_leftover/2
      bar_width = @window.width - 2*@first_x
    end
    
    last_card_x = @window.width - @first_x - card_width
    if card_number <= 1
      card_x_separation = 0
    else
      card_x_separation = (last_card_x - @first_x) / (card_number - 1)
    end
    
    card_views = Array.new
    for index in 0..(cards.length-1)    #CardView.new(window, card, x, y, z))
      card_views.push(CardView.new(@window, cards[index], @first_x + index*card_x_separation, @first_y, @z + 5*index))
    end
    return card_views
  end
  
  def draw()
    #@card_view.draw()
    @card_views.each{|card| card.draw()}
  end
  
  def card_in_position(x, y)
    #TODO
  end
  
end