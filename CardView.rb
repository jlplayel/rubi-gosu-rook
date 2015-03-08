require 'gosu'

class CardView  < Gosu:: Font
  
  BLACK = Gosu::Color.argb(0xff000000)
  GREEN = Gosu::Color.argb(0xff14ba14)
  RED = Gosu::Color.argb(0xffff0000)
  YELLOW = Gosu::Color.argb(0xffddbb00)
  #YELLOW = Gosu::Color.argb(0xffffff00)
  
  TEXT_HEIGHT = 50
  PADDING = 7
  
  attr_accessor :card, :first_x, :first_y, :z
  
  def initialize(window, card, x, y, z)
    @window = window
    @card = card
    @first_x = x
    @first_y = y
    @z = z
    if @card.is_special?
      @card_image = Gosu::Image.new(@window, "images/rook_card.png", true)
    else
      @card_image = Gosu::Image.new(@window, "images/background_card.png", true)
      @up_number = Gosu:: Font.new(@window, Gosu.default_font_name, TEXT_HEIGHT)
      @down_number = Gosu:: Font.new(@window, Gosu.default_font_name, TEXT_HEIGHT)
    end
    @hidden = false
  end
  
  def draw()
    if !card.is_special?
      @window.draw_quad(first_x+PADDING, first_y+PADDING, gosu_color,
                        third_x-PADDING, first_y+PADDING, gosu_color, 
                        third_x-PADDING, third_y-PADDING, gosu_color, 
                        first_x+PADDING, third_y-PADDING, gosu_color, z = @z, mode = :default)
      number1 = number2 = @card.number.to_s()
      if number2.length==1
        number2 = "  ".concat(number2)
      end
      @up_number.draw(number1, first_x+PADDING, first_y+PADDING, z+2, 1, 1, gosu_color, mode = :default)
      @down_number.draw(number2.center(2), third_x-55, third_y-55, z+2, 1, 1, gosu_color, mode = :default)
    end
    
    @card_image.draw(first_x, first_y, @z+1)
  end
  
  def is_in_area(x, y)
    result = true
    result = false if x < first_x or third_x < x
    result = false if y < first_y or third_y < y
    return result
  end
  
  def third_x
    first_x + width()
  end
  
  def third_y
    first_y + height()
  end
  
  def width()
    @card_image.width()
  end
  
  def height()
    @card_image.height()
  end
  
  def gosu_color
    if @gosu_color == nil
      case card.suit
        when "RED"
          @gosu_color = RED
        when "YELLOW"
          @gosu_color = YELLOW
        when "BLACK"
          @gosu_color = BLACK
        when "GREEN"
          @gosu_color = GREEN
      end
    end
    return @gosu_color
  end
  
  def is_in_area(x, y)
    result = true
    result = false if x < first_x or third_x < x
    result = false if y < first_y or third_y < y
    return result
  end
  
  def hidden?
    @hidden
  end
  
  def hide()
    @hidden = true
  end
  
  def unhide()
    @hidden = false
  end
  
  def clone()
    return CardView.new(@window, @card, @first_x, @first_y, @z)
  end
  
end