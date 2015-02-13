require 'gosu'  #gem install gosu

class CardTableDisplay < Gosu:: Window

  def initialize(tittle)
    @size_x = 640
    @size_y = 480
    super @size_x, @size_y, false, 100   #initialize(width, height, fullscreen, update_interval = 16.666666)
    self.caption = tittle
    @background_color = Gosu::Color.argb(0xff29A813)
    
    @pressed_x = 0
    @pressed_y = 0
    
    #@thing_image = Gosu::Image.new(self, "thing.gif", true)
    #SVGParser.new("background.svg").rect(@id).normalize!

    add_main_message("Hello, World! Testing what happend when the text is")
  end
  
  def update
    @view_show_message = true
    @view_show_hand = true
    @view_show_player_cards = true
    
  end
  
  def draw
    #Windows background
    draw_quad(0, 0, @background_color,
              @size_x, 0, @background_color, 
              @size_x, @size_y, @background_color, 
              0, @size_y, @background_color, z = 0, mode = :default)
    
    if @view_show_message
      @text_image.draw(10, 10, 1)
    end
              
               
    #@thing_image.draw(@pressed_x, @pressed_y ,1)
    #draw_line(640/3, 0, Gosu::Color.argb(0xffffffff), 640/3, 480, Gosu::Color.new(0xffffffff))
  end
  
  def needs_cursor?
    true #now we have a mouse
  end
  
  def buton_down(button_id)
    @thing_x = mouse_x
    @thing_y = mouse_y
  end
  
  def add_main_message(text)
    @text_image = Gosu::Image.from_text(self, text, Gosu.default_font_name, 30)
    @view_show_message = true
  end
  
  def remove_main_message()
    @view_show_message = false
  end

end  #class

window = CardTableDisplay.new("Rook Game")
window.show