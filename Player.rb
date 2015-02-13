class Player
  attr_accessor  :number, :name, :bet, :hand_cards, :round_points
  attr_reader :special_suit
  
  def initialize(number, name)
    @number = number
    @name = name
    @hand_cards = Array.new
    @bet = 0
    @special_suit = nil
    @round_points = 0
  end
  
  def clear_round_info()
    @hand_cards = Array.new
    @bet = 0
    @special_suit = nil
    @round_points = 0
  end
  
  def make_a_bet(bet_status)
    if bet_status[number-1]!="PASS"
      sort_hand_cards() unless bet_status[number-1]!=0
      clean_console()
      show_bet_status(bet_status)
      puts ""
      show_all_cards()
      bet = bet_status.select{|s| s!="PASS" && s!="PASS_PARTNER"}.sort{|x,y| y<=>x}[0]
      puts self.to_s()
      puts "Make your BET!! --> PASS:(0) - PASS_PARTNER(1) - BET:(#{bet+5}-200): "
      selected_bet = gets
      if selected_bet.to_i==0
        bet_status[number-1]="PASS"
      elsif selected_bet.to_i==1
        bet_status[number-1]="PASS_PARTNER"
      else
        bet_status[number-1]=selected_bet.to_i
      end
    end
    return bet_status
  end
  
  def show_bet_status(bet_status)
    puts "BETS JUST BEFORE:"
    for i in 1..3
      position = (number-1+i)%bet_status.length
      if bet_status[position]!=0
        puts "Player#{position+1} bet decision: #{bet_status[position]}"
      else
        puts "Player#{position+1} has not said bet yet."
      end
    end
  end
  
  # Added un group of n cards. They mixed with player hand cards. Player has to remove the same n number of cards.
  def exchange_cards(added_cards)
    exchange_number = added_cards.length
    puts "Remember! You cannot leave more than 10 points in the kitty. Cards in kitty: " + exchange_number.to_s
    @hand_cards.concat(added_cards).compact!
    sort_hand_cards()
    added_cards = Array.new
    for i in 1..exchange_number
      show_all_cards()
      show_card_options(@hand_cards)
      puts to_s() + " => (Picking up #{exchange_number} cards). Choose card #{i} (1-#{@hand_cards.length}) :"
      card_position = gets
      added_cards.push(@hand_cards.delete_at(card_position.to_i - 1))
    end
    added_cards
  end
  
  def show_card_options(card_options)
    # Hand list card
    puts card_options.join('  ')
    # Help numbers  
    card_options.each_index{|x| print "(#{x+1})" + " "*card_options[x].to_s.delete(":").length}
    puts ""
  end
  
  
  def show_all_cards()
    special_cards = @hand_cards.select{|c| c.suit==nil}
    if !special_cards.empty? #special_suit!=nil && !special_cards.empty?
      puts "Special card: " + special_cards[0].to_s + " " + (special_suit || "")
    end
    normal_cards = @hand_cards.select{|c| c.suit!=nil}
    suit_options = normal_cards.map{|c| c.suit}.uniq
    suit_options.each{
      |color| 
      puts color + ": " + normal_cards.select{|c| c.suit==color}.select{|c| !c.is_special?}.map{|c| c.number}.join('  ') +
        "  " + normal_cards.select{|c| c.suit==color}.select{|c| c.is_special?}.map{|c| c.special_card_name}.join('  ')
    }
    puts ""
    if special_suit!=nil
      puts "TRUMP: #{special_suit}"
    end
  end
  
  # Player choose which suit or color is going to be special considering the options.
  # TODO right now player can't not select one suit that it is not in one's card hand!!!!
  def pick_up_special_suit()
    puts "Player #{number} cards:"
    show_all_cards()
    suit_options = @hand_cards.select{|c| !c.is_special?}.map{|c| c.suit}.uniq
    puts "Pick the TRUMP up! Choose by position (1-#{suit_options.length}): #{suit_options.join('  ')}"
    selected_position = gets
    return suit_options[selected_position.to_i - 1]
  end
  
  def pick_hand_card(prioritary_suit)
    show_all_cards()
    card_options = @hand_cards
    if prioritary_suit!=nil && prioritary_suit!=""
      posible_card_options = @hand_cards.select{|c| c.suit==prioritary_suit}
      if !posible_card_options.empty?
        card_options = posible_card_options
      end
    end
    show_card_options(card_options)
    selected_card_position = card_options.length + 1
    while selected_card_position.to_i>card_options.length
      puts self.to_s()
      puts " => Picking up a card. Range (1-#{card_options.length}) :"
      selected_card_position = gets
    end
    selected_card = card_options[selected_card_position.to_i - 1]
    return @hand_cards.delete(selected_card)
  end
    
  def sort_hand_cards()
    no_number_cards = @hand_cards.select{|c| c.number==nil}
    number_cards = @hand_cards.select{|c| c.number!=nil}
    suit_options = number_cards.map{|c| c.suit}.uniq
    @hand_cards = no_number_cards
    suit_options.each{
      |color|       # First As or card 1, later from big to small
      color_cards = number_cards.select{|c| c.suit==color && c.number==1}.concat(
                      number_cards.select{|c| c.suit==color && c.number!=1}.sort{|x,y| y.number<=>x.number})
      @hand_cards = @hand_cards.concat(color_cards)
    }
  end
  
  def special_suit=(special_suit)
    @special_suit = special_suit
    special_cards = @hand_cards.select{|c| c.is_special?}
    if !special_cards.empty?
      special_cards.map{
        |c| 
        c.suit = special_suit
        c.number = 0
      }
      sort_hand_cards()
    end
  end
  
  def to_s()
    "Player: #{number} - Team: #{1+(number-1)%2} - Name: #{name}"
  end
  
  def clean_console()
    #puts RUBY_PLATFORM
    system('cls')
    system('clear')
    puts caller[0]
  end
  
end