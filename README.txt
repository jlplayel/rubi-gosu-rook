RUN ROOK GAME
- Install Ruby (version 1.9.3).
- Install Gosu library (Window console:> gem install gosu).
- Execute Rook.rb (Window console:> ruby Rook.rb).

RELATED LINKS
- About Rook game:
- About installing Ruby:
- About Gosu:
- About Portocarrero's sun:

RULES AND LIMITS OF THIS GAME VERSION
- You can play Rook with different rules, in this version:
	* Rook card, as Trump, has the lowest power versus the rest of the Trump.
	* You cannot leave more than 10 points in the Kitty.
- You can bet 200 points but you cannot "Shoot the moon".
- Four players, team1 (player1 & player 3), team2 (player2 & player 4).
- First team with more points over 500 wins the game.


FOR DEVELOPERS:
- Playing by console. (Change the value @points_for_end = 500 in Rook.rb)
- Changing the points for finishing the game. (Initialize $display = nil in Rook.rb)
- Possible points to improve

A) The game was developed for playing by console and later adapted for Gosu view library. So the code was forced for use Gosu in a way that it was not design for. In one hand with the idea of reuse the initial console version of the game and in the other hand to stay in the MVC pattern:
	* Model classes: Rook, Card, Player, Deck, DeckFactory (Console version)
	* View: CardTableWindow, DefaultWindow, CardView, Button, TextField, CardsBar
	* Controller: RookDisplay
For giving back the control to the game, the window is close between different views. This makes that the close button "X" in the corner of the window do not work properly, it pass you to the next view. Initially I expected other behaviour in window.close, my idea was to open a new window for every view. I check this option only for curiosity thinking I would not like the result and past to the next idea, giving back the control by raising exceptions. Anyway if you insist over "X" button you stop by braking the execution. The ideal would be to solve this.

B) Adding the option of "Shoot the moon" require to add tracking of every hand in a round, not only the points. Adding a flag that would be false in case the Team with the bet would loose a hand. Plus adding the new button to the view and adding the functionality to counting points.

C) Check if one player is going to win the rest of the hands in a round.

D) Make virtual player would be good thinking the one screen for 4 players, it is not really useful.

D) To make a menu, were the players came decide to star, change any setting, save points results or quit.