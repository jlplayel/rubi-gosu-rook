require 'gosu'     #gem install gosu
require 'rubygems' #For typing of buttons --> Gosu::KbTab 

require_relative "Button"
require_relative "TextField"
require_relative "DefaultWindow"
require_relative "CardsBar"

class CardTableWindow < Gosu:: Window
  include DefaultWindow
  
  attr_accessor  :button_state
  # state = "MESSAGE"; "TEXT_FIELD"; "BET_BUTTONS"
  
  def post_initialize()
    add_main_message("Window working!")
    @buttons = []
    @text_fields = []
    @show_font = false
    self.button_state = "MESSAGE"
  end
  
  def post_clean_all()
    self.button_state = "MESSAGE"
  end
  
  
  def draw
    color_background()
    
    if @show_hand_cards
      @hand_CardsBar.draw()
    end

    if @show_player_cards
      @player_CardsBar.draw()
    end
    
    if @show_font
      font_color = Gosu::Color.argb(0xffffffff)
      @font.draw(@font_value, @font_first_x, @font_first_y, 2, 1, 1, font_color, mode = :default)
    end
      
    if @show_buttons
      draw_buttons()
    end
    
    if @show_message
      @text_image.draw(10, 10, 1)
    end
    
    if @show_text_fields
      @text_fields.each { |tf| tf.draw }
    end
                    
    #@thing_image.draw(@pressed_x, @pressed_y ,1)
    #draw_line(640/3, 0, Gosu::Color.argb(0xffffffff), 640/3, 480, Gosu::Color.new(0xffffffff))
  end
  
  
  def button_down(button_id)
    case button_state
    when "TEXT_FIELD"
      puts "TEXT_FIELD buton_down --> Working!!!"
      text_fields_buttons(button_id)
    when "BET_BUTTONS"
      bet_buttons()
    else
      puts "default buton_down --> Working!!!"
      message_button()
    end
  end
  
  def bet_buttons()
    if @buttons[0].is_in_area(mouse_x, mouse_y) #Done
      if(@font_value != @init_font_value)
        @controller.selected_bet = @font_value
        clean_all()
        @controller.close_window
      end
    elsif @buttons[1].is_in_area(mouse_x, mouse_y) #Pass
      @font_value = "PASS"
    elsif @buttons[2].is_in_area(mouse_x, mouse_y) #Pass_partner
      @font_value = "PASS_PARTNER"
    elsif @buttons[3].is_in_area(mouse_x, mouse_y) #+5
      if @font_value.is_a?(Integer) && (@font_value+5)<=200
        @font_value += 5
      end
    elsif @buttons[4].is_in_area(mouse_x, mouse_y) #+10
      if @font_value.is_a?(Integer) && (@font_value+10)<=200
        @font_value += 10
      end
    elsif @buttons[5].is_in_area(mouse_x, mouse_y) #+50
      if @font_value.is_a?(Integer) && (@font_value+50)<=200
        @font_value += 50
      end
    elsif @buttons[6].is_in_area(mouse_x, mouse_y) #Bet Reset
      @font_value = @init_font_value
    end
  end
  
  def message_button()
    if @buttons[0].is_in_area(mouse_x, mouse_y)
      clean_all()
      @controller.close_window
    end
  end
  
  def text_fields_buttons(id) 
    if id == Gosu::KbTab then
      index = @text_fields.index(self.text_input) || -1
      self.text_input = @text_fields[(index + 1) % @text_fields.size]
    elsif id == Gosu::KbEscape then
      if self.text_input then
        self.text_input = nil
      else
        close
      end
    elsif id == Gosu::MsLeft then
      self.text_input = @text_fields.find { |tf| tf.under_point?(mouse_x, mouse_y) }
      self.text_input.move_caret(mouse_x) unless self.text_input.nil?
      if @buttons[0].is_in_area(mouse_x, mouse_y)
        @controller.player_names = @text_fields.collect {|tf| tf.text }
        clean_all()
        @controller.close_window
      end
    end
  end
  

  def add_font(text, text_height, first_x, first_y)
    @font = Gosu:: Font.new(self, Gosu.default_font_name, text_height)
    @font_value = @init_font_value = text
    @font_first_x = first_x
    @font_first_y = first_y
    @show_font = true
  end
  
  def remove_font()
    @font_value = ""
    @font_first_x = 0
    @font_first_y = 0
    @show_font = false
  end
    
  
end  #class

#window = CardTableDisplay.new("Rook Game")
#window.show