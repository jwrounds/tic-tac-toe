# Tic-Tac-Toe Board Mock-Up
# 
#  Key:
# 
# 0-0|0-1|0-2|
# 1-0|1-1|1-2|
# 2-0|2-1|2-2|
#
#  Terminal display:
#
# ___|_X_|_O_| 
# ___|_O_|___| 
# _X_|___|_X_|  
#
# Board:
# [ [false, false, X],
#   [false, X, false],
#   [O,     X, false] ]
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

  def render_board 
    self.game_board.each do |element|
      row = ""
      element.each do |space|
        if space
          row += "_#{space.symbol}_|"
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

class Token
  attr_reader :player, :symbol

  def initialize player, symbol
    @player = player
    @symbol = symbol
  end
end

class Player 
  attr_accessor :tokens
  attr_reader :name

  def initialize name 
    @name = name
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
  end

end

class Game
  attr_reader :board, :players
  attr_accessor :active_player, :winner

  def initialize player_one, player_two, board
    @players = [player_one, player_two]
    @winner = nil
    @board = board.game_board
    @active_player = player_one
    self.give_tokens player_one, "X"
    self.give_tokens player_two, "O"
  end

  def give_tokens player, symbol
    5.times do 
      player.tokens.push Token.new(player, symbol)
    end
  end

  def switch_players players
    players.each do |player|
      unless self.active_player == player
        self.active_player = player
      end
    end
  end

  def check_horizontal board
    winner = false
    board.each do |row|
      # reduces each row to either the token that occupies each space, or false if no winner
      winner = row.reduce do |memo, space|
        if memo && space
          memo.symbol == space.symbol ? space : false
        end
      end
    end
    if winner
      return winner.player
    end
    false
  end

  def check_vertical board
    column = 0

    # iterate over each space in three columns
    3.times do
      # in row count set to 1 to account for potential first token in each column 
      in_row = 1
      row = 0
      # initial space set to top row of each column
      start_val = board[row][column]
      2.times do
        # row incremented to compare against initial value
        row += 1
        # token check and comparison of initial and subsequent tokens in a given column if one present
        if start_val && board[row][column]
          if start_val.symbol == board[row][column].symbol  
            in_row += 1
            # new memo value to compare in next iteration
            start_val = board[row][column]
          end
        else
          # if no token or match found, break out of loop 
          break
        end
        if in_row == 3
          # if win condition met, value of winner's token returned
          return start_val.player
        end
      end
      column += 1
    end
    # returns false if win condition not met
    false
  end

  def check_diagonal board
    # check top left to bottom right
    row = 0
    column = 0
    in_row = 1
    start_val = board[row][column]

    2.times do
      row += 1
      column += 1

      if start_val && board[row][column]
        if start_val.symbol == board[row][column].symbol
          in_row += 1
          start_val = board[row][column]
        end
      else
        break
      end

      if in_row == 3
        return start_val.player
      end
    end

    # check top right to bottom left
    row = 0
    column = 2
    in_row = 1
    start_val = board[row][column]

    2.times do
      row += 1
      column -= 1
      
      if start_val && board[row][column]
        if start_val.symbol == board[row][column].symbol
          in_row += 1
          start_val = board[row][column]
        end
      else
        break
      end
      if in_row == 3
        return start_val.player
      end
    end
    false
  end

  def check_winner
    self.winner = 
      self.check_horizontal(self.board) || self.check_vertical(self.board) || self.check_diagonal(self.board)
    if self.winner
      puts "#{self.winner.name} wins!"
    end
  end

end

board = Board.new 
player_one = Player.new "Player1"
player_two = Player.new "Player2"
game = Game.new player_one, player_two, board

player_two.place_token 0, 0, board.game_board
player_two.place_token 1, 1, board.game_board
player_two.place_token 2, 2, board.game_board
player_one.place_token 0, 2, board.game_board
player_one.place_token 2, 0, board.game_board

board.render_board
game.check_winner
