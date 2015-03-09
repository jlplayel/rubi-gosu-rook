module DefaultWindow
  BACKGROUND_COLOR = Gosu::Color.argb(0xff29A813)
  SIZE_X = 1024
  SIZE_Y = 768
  TEXT_HEIGHT = 30
  BUTTON_PADDING = 20
  FONT = Gosu::default_font_name
  
  def initialize(tittle, controller)
    super SIZE_X, SIZE_Y, false, 100   #initialize(width, height, fullscreen, update_interval = 16.666666)
    self.caption = tittle
    @controller = controller
    
    @button_color = Gosu::Color.argb(0xffDA9D8A)
    
    @point_x = 0
    @point_y = 0
    
    set_states(true, true, false, false, false)
    post_initialize()
  end
  
  def set_states(show_message, show_buttons, show_text_fields, show_hand_cards, show_player_cards)
    @show_message = show_message
    @show_text_fields = show_text_fields
    @show_hand_cards = show_hand_cards
    @show_player_cards = show_player_cards
    @show_buttons = show_buttons 
  end
  
  def message_view(message_text, button_text)
    add_main_message(message_text)
    add_button(button_text, TEXT_HEIGHT, BUTTON_PADDING)
  end
  
  def add_main_message(text)
    #(Gosu::Image) from_text(window, text, font_name, font_height, line_spacing, width, align) 
    @text_image = Gosu::Image.from_text(self, text, FONT, 30, 10, SIZE_X, :left)
    @show_message = true
  end
  
  def add_button(text)
    add_setting_button(text, TEXT_HEIGHT, nil)
  end
  
  def add_setting_button(text, text_height, x_position)
    if x_position == nil
      x_position = get_x_position_depending_other_buttons()
    end
    y_position = SIZE_Y - text_height - BUTTON_PADDING
            #initialize(window, text, text_height, x, y, z, color)
    button = Button.new(self, text, text_height, x_position, y_position, 2, @button_color)
    @buttons.push(button)
  end
  
  def add_text_fields(text_field_number)
    text_size = TEXT_HEIGHT-10
    @text_fields = Array.new(text_field_number) { |index| TextField.new(self, FONT, text_size, 200, 130 + index * 80, "Player#{index+1}") }
    @show_text_fields = true
  end
  
  def add_hand_CardsBar(cards)
    @hand_CardsBar = CardsBar.new(self, cards, 5, 200, 5)
    @show_hand_cards = true
  end
  
  def add_player_CardsBar(cards)
    @player_CardsBar = CardsBar.new(self, cards, 5, 450, 5)
    @show_player_cards = true
  end
  
  def get_x_position_depending_other_buttons()
    if @buttons.length==0
      x_position = BUTTON_PADDING
    else
      x_position = @buttons[-1].third_x + BUTTON_PADDING
    end
    return x_position
  end
  
  def clean_buttons()
    @buttons.clear
  end
  
  def draw_buttons()
    @buttons.each{|button| button.draw()}
  end
  
  def color_background()
    draw_quad(0, 0, BACKGROUND_COLOR,
              SIZE_X, 0, BACKGROUND_COLOR, 
              SIZE_X, SIZE_Y, BACKGROUND_COLOR, 
              0, SIZE_Y, BACKGROUND_COLOR, z = 0, mode = :default)
  end
  
  def needs_cursor?
    true #now we have a mouse
  end
  
  def remove_main_message()
    @show_message = false
  end
  
  def post_initialize()
    raise "Expected 'post_initialize' Overwritten message."
  end
  
  def post_clean_all()
    raise "Expected 'post_clean_all' Overwritten message."
  end
  
  def clean_all()
    @buttons.clear
    @text_fields.clear
    #@hand_CardsBar = nil
    #@player_CardsBar = nil
    set_states(true, true, false, false, false)
    post_clean_all()
  end
  
end