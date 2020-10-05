# Tic-Tac-Toe Board Mock-Up
# 
#  Key:
# 
#  0-0 | 0-1 | 0-2 
#  ----|-----|----
#  1-0 | 1-1 | 1-2 
#  ----|-----|----
#  2-0 | 2-1 | 2-2  
#
#  Terminal display:
#
#  x | x | o 
#  _ | o | _  
#  _ | _ | x  
#

class Board
  @@game_active = false
  attr_reader :game_board

  def initialize player_one, player_two
    @players = [player_one, player_two]
    @game_board = []
    @@game_active = true
    
    self.build_board
  end

  def build_board 
    3.times do |i|
      board_row = []
      3.times do |j|
        board_row.push [i, j]
      end
      @game_board.push board_row
    end
  end

end

class Player 

  def initialize name 
    @name = name
  end

end

class Piece

end

class Game 

end

new_board = Board.new "john", "joe"
p new_board.game_board