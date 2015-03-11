require 'gosu'
require_relative "CardView"

class CardsBar
  
  PRIORITY_MARK_COLOR = Gosu::Color.argb(0x7729A813)
  
  def initialize(window, cards, x, y, min_z, priority_suit)
    @window = window
    @first_x = @init_padding = x
    @first_y = y
    @z = min_z
    @priority_suit = priority_suit
    if cards == nil
      cards = Array.new
      @card_views = Array.new
    else
      @card_views = organize_card_views(cards)
    end
  end
   
  def organize_card_views(cards)
    @first_x = @init_padding 
    card_number = cards.length
    puts "Initial card_view number: #{card_number}"
    card_width = CardView.new(@window, cards[0], 0, 0, 5).width()
    
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
        card_views.push(CardView.new(@window, cards[index], @first_x + index*card_x_separation, @first_y, @z + 5*index + suit_priority_z(cards[index])))
    end
    return card_views
  end
  
  def suit_priority_z(card)
    if @priority_suit!=nil && card.suit.eql?(@priority_suit)
      return 100
    else
      return 0
    end
  end
  
  def minimum_z()
    if @priority_suit!=nil
      return 100
    end
    return 0
  end
  
  def draw()
    @card_views.each{|card_view| card_view.draw() unless card_view.hidden?}
    
    if @priority_suit!=nil
      @window.draw_quad(0, @first_y, PRIORITY_MARK_COLOR,
                        @window.width, @first_y, PRIORITY_MARK_COLOR, 
                        @window.width, third_y, PRIORITY_MARK_COLOR, 
                        0, third_y, PRIORITY_MARK_COLOR, z = minimum_z(), mode = :default)
    end
  end
  
  def get_card_view_in_position(x, y)
    picked_card_view = nil
    if @first_y<y && y<third_y
      card_position = @card_views.length-1
      while card_position >=0
        if !@card_views[card_position].hidden? && @card_views[card_position].is_in_area(x, y, minimum_z())
          picked_card_view = @card_views[card_position]
          break
        end
        card_position = card_position - 1
      end
    end
    return picked_card_view
  end
  
  def third_y
    if length==0
      return @first_y
    end
    return @card_views[0].third_y
  end
  
  def length
    @card_views.length
  end
  
  def cards()
    return @card_views.collect{|card_view| card_view.card}
  end
  
  def card_views()
    return @card_views
  end
  
  def add(card_view)
    puts "Initial card_view number: #{cards.length}"
    cards = @card_views.collect{|card_view| card_view.card}
    puts "Added: #{cards}"
    cards.push(card_view.card)
    puts "Added: #{cards}"
    @card_views = organize_card_views(cards)
  end
  
  def remove(hand_card_view)
    @card_views.delete(hand_card_view)
    reorganize_card_views()
  end
  
  def remove_at(index)
    @card_views.delete_at(index)
    reorganize_card_views()
  end
  
  def reorganize_card_views()
    if @card_views.length > 0
      @card_views = organize_card_views(@card_views.collect{|card_view| card_view.card})  
    end
  end
  
end