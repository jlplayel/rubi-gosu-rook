require 'gosu'  #gem install gosu

require_relative "Rook"
require_relative "Button" 

class CardTableDisplay < Gosu:: Window

  def initialize(tittle)
    @size_x = 640
    @size_y = 480
    super @size_x, @size_y, false, 100   #initialize(width, height, fullscreen, update_interval = 16.666666)
    self.caption = tittle
    @background_color = Gosu::Color.argb(0xff29A813)
    @button_color = Gosu::Color.argb(0xffDA9D8A)
    
    @point_x = 0
    @point_y = 0
    
    #@thing_image = Gosu::Image.new(self, "thing.gif", true)
    #SVGParser.new("background.svg").rect(@id).normalize!

    #add_main_message("Hello, World! Testing what happend when the text is")
    add_main_message("Welcome to the Rook Game!\n Press \"OK\" button for starting!")
    
    #buttons
    #initialize(window, text, text_height, x, y, z, color)
    text_height = 30
    x_position = 20
    y_position = @size_y - text_height - x_position
    button = Button.new(self, "   OK   ", text_height, x_position, y_position, 2, @button_color)
    @buttons = []
    @buttons.push(button)
    
    @view_show_message = true
    @view_show_hand = false
    @view_show_player_cards = false
    @view_show_buttons = true
    
    #About the game
    @rook_game = Rook.new()
  end
  
  def update
    
  end
  
  def draw
    color_background()
    
    if @view_show_buttons
      draw_buttons()
    end
    
    if @view_show_message
      @text_image.draw(10, 10, 1)
    end
              
               
    #@thing_image.draw(@pressed_x, @pressed_y ,1)
    #draw_line(640/3, 0, Gosu::Color.argb(0xffffffff), 640/3, 480, Gosu::Color.new(0xffffffff))
  end
  
  def draw_buttons()
    @buttons.each{|button| button.draw()}
  end
  
  def color_background()
    draw_quad(0, 0, @background_color,
              @size_x, 0, @background_color, 
              @size_x, @size_y, @background_color, 
              0, @size_y, @background_color, z = 0, mode = :default)
  end
  
  def needs_cursor?
    true #now we have a mouse
  end
  
  def button_down(button_id)
    @point_x = mouse_x
    @point_y = mouse_y
    puts "buton_down --> Working!!!"
    if @buttons[0].is_in_area(mouse_x, mouse_y)
      @view_show_buttons = false
    end
  end
  
  def add_main_message(text)
    #(Gosu::Image) from_text(window, text, font_name, font_height, line_spacing, width, align) 
    @text_image = Gosu::Image.from_text(self, text, Gosu.default_font_name, 30, 10, @size_x, :left)
    @view_show_message = true
  end
  
  def remove_main_message()
    @view_show_message = false
  end

end  #class

window = CardTableDisplay.new("Rook Game")
window.show