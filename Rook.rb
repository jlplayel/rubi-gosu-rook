require_relative "Player"
require_relative "DeckFactory"
require_relative "Deck"
require_relative "RookDisplay"

class Rook
  
  #Game attributes
  @points_for_end
  @players
  @team_points_table
  @first_player_position_in_round
  
  #Round attributes
  @kitty
  @trump
  @deck
  
  def initialize()
    $display = RookDisplay.new("ROOK GAME")
    @points_for_end = 200
    @players = Array.new
    @team_points_table = create_new_points_table()
    @first_player_position_in_round = rand(0..4)
  end
  
  def start_game()
    presentation()
    make_teams()
    while not is_there_winner?  do
      play_round()
    end  
  end
  
  def presentation()
    puts "Welcome to the Rook Game. Press 'enter' for starting"
    if $display==nil
      gets
    else
      $display.show_presentation()
    end
  end
  
  def play_round()
    clean_console()
    puts "STARTING A NEW ROUND!!!"
    init_round()
    initial_player_position = get_bet_player_position()
    get_final_kitty(initial_player_position)
    select_trump(initial_player_position)
    play_hands(initial_player_position)
    check_round_winner(initial_player_position)
  end
  
  
  def check_round_winner(init_player_position)
    teams_card_points = [@players[0].round_points + @players[2].round_points, 
                         @players[1].round_points + @players[3].round_points]
    team_with_bet_position = init_player_position % 2
    bet_goal = @players[init_player_position].bet
    # Points for team with bet goal
    if teams_card_points[team_with_bet_position] >= bet_goal
      add_points_to_team(team_with_bet_position, teams_card_points[team_with_bet_position])
      puts "Team #{team_with_bet_position+1} got its goal!!!!!"
    else
      add_points_to_team(team_with_bet_position, -bet_goal)
      puts "Team #{team_with_bet_position+1} did NOT get its goal!!!!!"  
    end
    # Points for team without goal
    add_points_to_team((team_with_bet_position+1)%2, teams_card_points[(team_with_bet_position+1)%2])
    gets
  end
  
  def init_round()
    @first_player_position_in_round = next_player_position(@first_player_position_in_round)
    @kitty = Array.new
    @trump = ""
    df = DeckFactory.new({}) 
    @deck = Deck.new(df).shuffle().cut().shuffle().cut()
    @players.each{|player| player.clear_round_info()}
    dealing_cards()
  end
  
  def select_trump(player_position)
    @trump =  @players[player_position].pick_up_special_suit()
    @players.map{|p| p.special_suit = @trump}
  end
  
  def get_final_kitty(player_position)
    clean_console()
    valid_kitty = false
    while not valid_kitty do
      puts "Kitty exchange! Remember the TRUMP, next step!"
      @kitty = @players[player_position].exchange_cards(@kitty)
      if count_points(@kitty)<=10
        valid_kitty = true
      end
    end
  end
  
  #TODO
  def play_hands(init_player_position)
    first_player_position = init_player_position
    while @players[0].hand_cards.length > 0 do
      hand_cards = Array.new
      puts "NEW HAND! Players.length-> #{@players.length}"
      # A turn per player in a hand
      #first_player_suit = nil
      for turn in 0..(@players.length-1)
        clean_console()
        puts "Next PLAYER decision: ".concat(@players[next_player_position(first_player_position - 1 + turn)].to_s())
        if $display == nil
          gets
          clean_console()
        end
        puts ""
        puts "Hand cards: " + hand_cards.join("  ")
        if @trump!=nil && @trump!=""
          puts "" 
          puts "TRUMP: " + @trump
        end
        puts ""
        hand_cards.push(@players[next_player_position(first_player_position - 1 + turn)].pick_hand_card(hand_cards))
        #hand_cards.push(@players[next_player_position(first_player_position - 1 + turn)].pick_hand_card(first_player_suit))
        #first_player_suit = hand_cards[0].suit
      end
      puts "Full hand cards: " + hand_cards.join("  ")
      # Getting the hand points
      hand_points = count_points(hand_cards)
      if @players[0].hand_cards.length==0
        hand_points = hand_points + count_points(@kitty) + 20
      end
      # Winner get the points of the hand and is the first next hand
      @players[first_player_position].round_points = @players[first_player_position].round_points + hand_points
      if $display == nil
        gets
      else
        $display.show_hand_winner(hand_cards, @players[first_player_position], hand_points)
      end
      first_player_position = (first_player_position + get_hand_winner_position(hand_cards))%4
    end
  end
  
  def get_hand_winner_position(cards)
    raise "The array of cards cannot be nil or empty!!!" unless cards!=nil || cards.length==0
    if cards.length==1
      return 0
    end
    #trump
    trump_cards = cards.select{|c| c.suit==@trump}
    winner_card = get_winner_card_with_some_suit(trump_cards)
    puts "Trump winner card: " + winner_card.to_s
    #first card suit
    if winner_card==nil
      first_card_color = cards[0].suit
      same_color_cards = cards.select{|c| c.suit==first_card_color}
      winner_card = get_winner_card_with_some_suit(same_color_cards)
      puts "Color winner card: " + winner_card.to_s
    end
    puts "Hand winner card: " + winner_card.to_s
    puts "Winner position in hand: " + cards.index(winner_card).to_s
    if $display == nil
      gets
    end
    #position of that card
    return cards.index(winner_card)
  end 
  
  def get_winner_card_with_some_suit(cards)
    if cards.length==0
      return nil
    elsif cards.length==1
        return cards[0]
    else
      cards.each{
        |c|
        if !c.is_special? && c.number==1
          return c
        end
      }
      #If there's one then the biggest is the winner
      card_aux = cards.sort{|x,y| y.number<=>x.number}
      return card_aux[0]
    end
  end 
  
  def count_points(cards)
    total_points = 0
    cards.each{
        |card|
        total_points = total_points + card.points
    }
    return total_points
  end
  
  def get_bet_player_position()
    bet_points = -1
    player_position = -1
    bet_status = Array.new(@players.length){0}
    i = 0
    while bet_points==-1 do
      player_position = next_player_position(@first_player_position_in_round+i-1)
      bet_status = @players[player_position].make_a_bet(bet_status)
      puts "BETs are #{bet_status}"
      no_pass_array = bet_status.select{|s| s!="PASS"}
      bet_points=no_pass_array[0] unless no_pass_array.length>1
      i+=1
    end
    player_position = bet_status.index(bet_points)
    puts "Player#{player_position+1} got the challenge of: #{bet_points} bet points."
    if $display == nil
      gets
    else
      $display.show_final_bet(bet_points, @players[player_position])
    end
    @players[player_position.to_i - 1].bet = bet_points.to_i
    @players[next_player_position(player_position.to_i)].bet = bet_points.to_i
    player_position.to_i
  end
  
  def dealing_cards()
      for i in 0..4
        deal_a_card_per_person()
        @kitty.push(@deck.next_card())
      end
      while @deck.number_of_cards()>0 do
        deal_a_card_per_person()
      end
  end
  
  def deal_a_card_per_person()
    for i in 0..(@players.length-1)
      player_position = next_player_position(@first_player_position_in_round+i-1)
      @players[player_position].hand_cards.push(@deck.next_card())
    end
  end
  
  def next_player_position(position)
    (position+1)%(@players.length)
  end
  
  def is_there_winner?
    return true if team_with_point(@points_for_end)
    false
  end
  
  def team_with_point(end_points)
    team1_points = @team_points_table[0].reduce(:+)
    team2_points = @team_points_table[1].reduce(:+)
    if team1_points >= end_points || team2_points >= end_points
      show_game_winner(team1_points, team2_points)  #TODO remove from here, 2 responsabilities!!!!!
      return true
    end
    return false
  end
  
  
  def show_game_winner(team1_points, team2_points)
    if team1_points >= @points_for_end || team2_points >= @points_for_end
      if team1_points > team2_points
        puts "Team ONE has won with #{team1_points} points vs team two with #{team2_points} points!!!!"
      elsif team1_points = team2_points
        puts "No winner, game finish in DRAW with #{team1_points} points in both teams!!!!"
      else
        puts "Team TWO has won with #{team2_points} points vs team one with #{team1_points} points!!!!"
      end
      return true
    end
      return false
  end
  
  
  def make_teams()
    if $display==nil
      names = make_teams_by_console()
    else
      names = $display.get_player_names()
    end
    
    for p in 1..names.length
      @players.push(Player.new(p, names[p-1]))
    end
    show_teams()
  end
  
  def make_teams_by_console()
    names = Array.new
    for p in 0..3
         puts "Name of the Player #{1+(p)%2} in the Team #{1+p/2}? (Default 'Player#{p+1}')"
         name = gets.chomp
         if name==nil || name==""
           name = "Player#{p+1}"
         end
         names.push(name)
    end
    names
  end
  
  def show_teams()
    clean_console()
    @players.each{ |player|
      puts player
    }
    if $display!=nil
      names = $display.show_teams(@players)
    end
  end
  
  def clean_console()
    #puts RUBY_PLATFORM
    system('cls')
    system('clear')
    puts caller[0]
  end
  
  def create_new_points_table()
    team_points_table = Array.new(2){ Array.new }   
    team_points_table[0][0] = 0
    team_points_table[1][0] = 0
    team_points_table
  end
  
  def add_points_to_team(team_position, team_points)
    # Team 0 -> Players 0 and 2
    # Team 1 -> Players 1 and 3
    @team_points_table[team_position].push(team_points)
  end
  
end #end class

rook = Rook.new()
rook.start_game()