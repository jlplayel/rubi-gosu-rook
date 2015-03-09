require_relative "CardTableWindow"

class RookDisplay
  attr_accessor :player_names, :selected_bet, :kitty, :trump, :selected_player_card
  @window
  
  def initialize(tittle)
    @tittle = tittle
    @window = CardTableWindow.new(@tittle, self)
  end
  
  def show_presentation()
    message = "\n\n\n\n<b>Welcome to the Rook Game!</b>\n Press \"Start\" button for starting..."
    @window.add_main_message(message)
    @window.add_button("Start".center(11))
    @window.show
  end
  
  def get_player_names()
    @player_names = Array.new
    @window.button_state = "TEXT_FIELD"
    @window.add_main_message("<b>PLAYER NAMES</b>\nPlayer1 and Player3 VS. Player2 and Player4.\nPlayer 1 name:\n\nPlayer 2 name:\n\nPlayer 3 name:\n\nPlayer 4 name:")
    @window.clean_buttons()
    @window.add_button("Done".center(11))
    @window.add_text_fields(4)
    @window.show
    return self.player_names
  end
  
  def show_teams(players)
    message = "<b>TEAMS</b>\nTeam 1:\n    #{players[0].name}   &  #{players[2].name}\n" +
                  "VS\nTeam 2:\n    #{players[1].name}  &  #{players[3].name}"
    @window.add_main_message(message)
    @window.add_button("Start Game".center(11))
    @window.show
  end
  
  def ask_for_player(player)
    @window.clean_all()
    message = "\n\n\n\n<b>TURN OF PLAYER #{player.number}: #{player.name}</b>\n" +
                "Press 'Next' button if you are the player..."
    @window.add_main_message(message)
    @window.clean_buttons()
    @window.add_button("Next".center(11))
    @window.show
  end
  
  def make_a_bet(bet_status, player)
    ask_for_player(player)
    message = bet_message_for_player(bet_status, player)
    @window.button_state = "BET_BUTTONS"
    @window.add_main_message(message)
    @window.add_font(last_bet(bet_status, player), 50, 220, 320) #(..., text_size, x, y)
    @window.add_player_CardsBar(player.hand_cards)
    @window.clean_buttons()
    @window.add_button("Done".center(12))
    @window.add_button("PASS".center(10))
    @window.add_button("PASS_PARTNER".center(14))
    @window.add_button("+5".center(10))
    @window.add_button("+10".center(10))
    @window.add_button("+50".center(10))
    @window.add_button("Bet Reset".center(12))
    @window.show
    @window.remove_font
    if self.selected_bet.is_a?(String)
      if(self.selected_bet.eql?("PASS"))
        return "0"
      else
        return "1"
      end
    else
      return self.selected_bet
    end
  end
  
  def show_final_bet(bet_points, player)
    team_number = (player.number-1)%2+1
    message = "\n\n\n\n<b>#{player.name} got the challenge!</b>\n" +
                "So <b>Team #{team_number}</b> has to get <b>#{bet_points}</b> points or more..."
    @window.add_main_message(message)
    @window.add_button("Next".center(12))
    @window.show
  end
  
  def last_bet(bet_status, player)
    player_position = player.number-1
    last_bet = ""
    while !(last_bet.is_a? Integer)
      player_position = (player_position-1)%4
      last_bet = bet_status[player_position]
    end
    return last_bet
  end
  
  def bet_message_for_player(bet_status, player)
    message = "\n<b>It is #{player.name} time to bet:</b>\n\n"
    first_bet = true
    player_position = player.number-1
    if bet_status[player_position]!=0
      message.concat("  Your last BET was: #{bet_status[player_position]}\n")
      first_bet = false
    else
      message.concat("\n")
    end
    player_position = (player_position+1)%4
    if bet_status[player_position]!=0
      message.concat("  Opponent player #{player_position+1} bet: #{bet_status[player_position]}\n")
      first_bet = false
    else
      message.concat("\n")
    end
    player_position = (player_position+1)%4
    if bet_status[player_position]!=0
      message.concat("  Your partner player #{player_position+1} bet: #{bet_status[player_position]}\n")
      first_bet = false
    else
      message.concat("\n")
    end
    player_position = (player_position+1)%4
    if bet_status[player_position]!=0
      message.concat("  Opponent player #{player_position+1} bet: #{bet_status[player_position]}\n")
      first_bet = false
    end
    if first_bet == true
      message.concat("This is the first bet of this round.\n")
    end
    message.concat("\n<b>You're going to:</b>\n")
    return message
  end
  
  def get_kitty(exchange_number, player)
    message = "\n<b>Choose the #{exchange_number} Kitty's cards, #{player.name}.</b>\n" +
                "Remember! You cannot leave more than 10 points in the kitty."
    @window.button_state = "KITTY_CARDS"
    @window.add_main_message(message)
    @window.add_hand_CardsBar(nil)
    @window.add_player_CardsBar(player.hand_cards)
    @window.add_button("Done".center(12))
    @window.show
    player.hand_cards = player.hand_cards - self.kitty
    return self.kitty
  end
  
  def get_trump(player)
    message = "\n<b>Choose the TRUMP  color, #{player.name}.</b>\n"
    @window.button_state = "TRUMP"
    @window.add_main_message(message)
    @window.add_player_CardsBar(player.hand_cards)
    @window.add_button("BLACK".center(12))
    @window.add_button("GREEN".center(12))
    @window.add_button("RED".center(12))
    @window.add_button("YELLOW".center(12))
    @window.show
    return self.trump
  end
  
  def pick_hand_card(hand_cards,card_options, player)
    message = "\n<b>#{player.name} is your turn!</b>\n" +
                "Add your played card to the hand and press \"Done\"...\n" +
                "Remember TRUMP is #{player.special_suit}\n" +
                "<b>Cards of this hand:</b>"               
    @window.button_state = "PLAYER_HAND_CARD"
    @window.general_flag = hand_cards.length
    @window.add_main_message(message)
    if hand_cards!=nil && hand_cards.length==0 #It is first step of this hand.
      @window.add_hand_CardsBar(nil)
    else
      @window.add_hand_CardsBar(hand_cards)
    end
    @window.add_player_CardsBar(player.hand_cards)
    @window.add_button("Done".center(12))
    @window.show
    return self.selected_player_card
  end
  
  def show_hand_winner(hand_cards, player, hand_points)
    message = "\n\n<b>#{player.name} won the hand!</b>\n So, Team #{((player.number-1)%2)+1} got #{hand_points} points."
    @window.button_state = "MESSAGE"
    @window.add_main_message(message)
    @window.add_hand_CardsBar(hand_cards)
    @window.add_button("Next".center(11))
    @window.show
  end
  
  def close_window()
    @window.close
  end
  
  
end