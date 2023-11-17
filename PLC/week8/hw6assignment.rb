# University of Washington, Programming Languages, Homework 6

class MyPiece < Piece
  ALL_MY_PIECES = All_Pieces +
                  [
                    [[[0, 0], [-2, 0], [-1, 0], [1, 0], [2, 0]], # extra long
                     [[0, 0], [0, -2], [0, -1], [0, 1], [0, 2]]],
                    rotations([[0, 0], [1, 0], [-1, 0], [-1, -1], [0, -1]]), # P/d
                    rotations([[0, 0], [0, -1], [1, 0]]) # v
                  ].freeze

  CHEAT_PIECE = [[[0, 0]]].freeze

  def self.next_piece(board)
    MyPiece.new(ALL_MY_PIECES.sample, board)
  end

  def self.cheat_piece(board)
    MyPiece.new(CHEAT_PIECE, board)
  end
end

class MyBoard < Board
  def initialize(game)
    super(game)
    @current_block = MyPiece.next_piece(self)
    @cheat_enabled = false
  end

  def rotate_180
    @current_block.move(0, 0, 2) if !game_over? && @game.is_running?
    draw
  end

  def cheat
    return if @score < 100 || @cheat_enabled

    @cheat_enabled = true
    @score -= 100
    @game.update_score
  end

  def next_piece
    if @cheat_enabled
      @current_block = MyPiece.cheat_piece(self)
      @cheat_enabled = false
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0...locations.size).each do |i|
      current = locations[i]
      @grid[current[1] + displacement[1]][current[0] + displacement[0]] =
        @current_pos[i]
    end
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    @root.bind('u', proc { @board.rotate_180 })
    @root.bind('c', proc { @board.cheat })
  end
end
