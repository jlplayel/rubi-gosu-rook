require 'gosu'

class Button  < Gosu:: Font
  attr_accessor :text, :first_x, :first_y, :z, :color
  
  def initialize(window, text, text_height, x, y, z, color)
    @window = window
    @text = text
    @text_height = text_height
    @first_x = x
    @first_y = y
    @z = z
    @color = color
    #(Font) initialize(window, font_name, height) 
    super(window, Gosu.default_font_name, text_height)
  end
  
  def draw()
    #(void) draw(text, x, y, z, factor_x = 1, factor_y = 1, color = 0xffffffff, mode = :default)
    @window.draw_quad(first_x, first_y, color,
                      third_x, first_y, color, 
                      third_x, third_y, color, 
                      first_x, third_y, color, z = @z, mode = :default)
    super(text, first_x, first_y, z+1, 1, 1, color = 0xffffffff, mode = :default)
  end
  
  def is_in_area(x, y)
    result = true
    result = false if x < first_x or third_x < x
    result = false if y < first_y or third_y < y
    return result
  end
  
  def third_x
    first_x + text_width(text, factor_x=1)
  end
  
  def third_y
    first_y + @text_height
  end
  
  def color
    @color
  end
end