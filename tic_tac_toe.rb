# Tic-Tac-Toe Board Mock-Up
# 
#  Key:
# 
#  0-0 | 0-1 | 0-2 |
#  ----|-----|-----|
#  1-0 | 1-1 | 1-2 |
#  ----|-----|-----|
#  2-0 | 2-1 | 2-2 |
#
#  Terminal display:
#
# ___|_X_|_O_| 
# ___|_O_|___| 
# _X_|___|_X_|  
#

class Board
  attr_reader :game_board

  def initialize   
    @game_board = []
    self.build_board
  end

  def build_board 
    3.times do 
      board_row = []
      3.times do 
        board_row.push false
      end
      @game_board.push board_row
    end
  end

end

class Player 
  attr_accessor :tokens
  attr_reader :is_turn

  def initialize name 
    @name = name
    @is_turn = false
    @tokens = []
  end

  def place_token space_key_one, space_key_two, board
    token = self.tokens.shift
    if board[space_key_one][space_key_two]
      puts "Please select an empty space.
            \n"
    else  
      board[space_key_one][space_key_two] = token
    end
    @is_turn = false
  end

end

class Game
  attr_reader :board

  def initialize player_one, player_two, board
    @players = [player_one, player_two]
    @winner = nil
    @board = board
    self.give_tokens player_one, "X"
    self.give_tokens player_two, "O"
  end

  def give_tokens player, symbol
    5.times do 
      player.tokens.push symbol
    end
  end

  def render_board board
    board.each do |element|
      row = ""
      element.each do |space|
        if space
          row += "_#{space}_|"
        else
          row += "___|"
        end
      end
      puts row    
    end
    puts "\n************
          \n"
  end

end

new_board = Board.new 
player_one = Player.new "Player1"
player_two = Player.new "Player2"
new_game = Game.new player_one, player_two, new_board
new_game.render_board(new_board.game_board)
player_one.place_token 0, 0, new_board.game_board
new_game.render_board(new_board.game_board)
player_two.place_token 0, 0, new_board.game_board
