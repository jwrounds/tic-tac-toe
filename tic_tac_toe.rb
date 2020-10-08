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
  attr_accessor :is_full

  def initialize   
    @game_board = []
    @is_full = false
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

  def is_full?
    self.is_full = self.game_board.each do |row|
      if row.include? false 
        return false
      end
    end
    self.is_full = true
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
  attr_accessor :move_made
  attr_reader :name, :symbol

  def initialize name, symbol 
    @name = name
    @move_made = false
    @symbol = symbol
  end

  def place_token space_key_one, space_key_two, board
    token = Token.new self.name, self.symbol
    if board[space_key_one][space_key_two]
      puts " \n#{self.name} attempted to place a token"
      puts " \nPlease select an empty space.\n "
    else  
      puts " \n#{self.name} placed a token\n "
      board[space_key_one][space_key_two] = token
      self.move_made = true
      
    end
  end

end

class Game
  attr_reader :board 
  attr_accessor :active_player, :winner, :players

  def initialize player_one, player_two, board
    @players = [player_one, player_two]
    @winner = false
    @board = board
    @active_player = player_one
  end

  def switch_players
    if self.active_player.move_made 
      if self.active_player == self.players.first
        self.active_player = self.players.last
      else
        self.active_player = self.players.first
      end
    end
  end

  def check_horizontal board
    board.each do |row|
      # reduces each row to either the token that occupies each space, or false if no winner
      winner = row.reduce do |memo, space|  
        if memo && space
          memo.symbol == space.symbol ? memo = space : false
        end
      end
      if winner
        return winner.player
      end
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
      self.check_horizontal(self.board.game_board) || self.check_vertical(self.board.game_board) || self.check_diagonal(self.board.game_board)
    if self.winner
      self.board.render_board
      puts "#{self.winner} wins!"
    elsif self.board.is_full?
      puts "Tie game! No one wins!\n************
      \n"
      self.winner = "Tie"
    end
  end

  def reset_turn
    self.switch_players
    self.check_winner
    self.active_player.move_made = false
  end

end

def play
    puts "Enter player one's name:"
    player_one_name = gets 
    player_one = Player.new player_one_name.chomp, "X"
    
    puts "Enter player two's name:"
    player_two_name = gets 
    player_two = Player.new player_two_name.chomp, "O"
    p player_two.name
    
    board = Board.new 
    game = Game.new player_one, player_two, board
    

    until game.winner
      until game.active_player.move_made
        board.render_board
        puts "Enter the coordinates of the space you'd like place your token. Exmple: 0-0 or 00 designates top left square. 0-1 or 01 designates top middle square\n "
        move = gets
        row = move.chomp.chars.first.to_i
        column = move.chomp.chars.last.to_i
        game.active_player.place_token row, column, board.game_board
      end
      game.reset_turn
    end
end

play