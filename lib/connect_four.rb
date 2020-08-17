class Board
  attr_accessor :columns, :black, :white
  def initialize(black, white)
    @black = black
    @white = white
    @columns = make_columns
  end

  def make_columns
    array = Array.new(7)
    array.map! do |_value|
      Column.new
    end
  end

  def insert(color, column)
    symbol = color == 'black' ? 'B' : 'W'
    @columns[column].contents.delete_if { |x| x == '*' }
    @columns[column].contents.push(symbol)
    @columns[column].contents.push('*') until @columns[column].contents.length == 6
  end

  def check
    if check_vertical == true || check_horizontal == true || check_diagonal == true
      true
    else
      false
    end
  end

  def check_vertical
    winner = false
    @columns.each do |column|
      counter = 0
      until counter == 3
        if column.contents[counter] == 'B' || column.contents[counter] == 'W'
          if column.contents[counter..(counter + 3)].uniq.length == 1
            winner = true
          end
        end
        counter += 1
      end
    end
    winner
  end

  def check_horizontal
    winner = false
    rows = (0..5).to_a
    rows.each do |row|
      counter = 0
      until counter == 4
        if @columns[counter].contents[row] == 'B' || @columns[counter].contents[row] == 'W'
          checking_array = []
          @columns[counter..(counter + 3)].each do |column|
            checking_array.push(column.contents[row])
          end
          if checking_array.uniq.length == 1
            winner = true
          end
        end
        counter += 1
      end
    end
    winner
  end

  def check_diagonal
    if check_diagonal_left == true || check_diagonal_right == true
      true
    else
      false
    end
  end

  def check_diagonal_left
    winner = false
    column_counter = 0
    until column_counter == 4
      row_counter = 0
      until row_counter == 3
        if @columns[column_counter].contents[row_counter] == 'B' || @columns[column_counter].contents[row_counter] == 'W'
          checking_array = []
          @columns[column_counter..(column_counter + 3)].each_with_index do |column, index|
            checking_array.push(column.contents[row_counter + index])
          end
          if checking_array.uniq.length == 1
            winner = true
          end
        end
        row_counter += 1
      end
      column_counter += 1
    end
    winner
  end

  def check_diagonal_right
    winner = false
    column_counter = 6
    until column_counter == 2
      row_counter = 0
      until row_counter == 3
        if @columns[column_counter].contents[row_counter] == 'B' || @columns[column_counter].contents[row_counter] == 'W'
          checking_array = []
          @columns[(column_counter - 3)..column_counter].each_with_index do |column, index|
            checking_array.push(column.contents[row_counter + 3 - index])
          end
          if checking_array.uniq.length == 1
            winner = true
          end
        end
        row_counter += 1
      end
      column_counter -= 1
    end
    winner
  end

  def ask_for_column(player)
    puts "#{player}, which column do you want to place in?"
    input_flag = false
    until input_flag
      print 'Column: '
      selection = gets.chomp
      if ('0'..'6').to_a.include?(selection) 
        if @columns[selection.to_i].full == false
          input_flag = true
        end
      else
        puts 'PLEASE INPUT A VALID COLUMN'
      end
    end
    puts "\n"
    selection.to_i
  end

  def show
    counter = 5
    puts '0  1  2  3  4  5  6'
    puts "\n"
    until counter == -1
      @columns.each do |column|
        print "#{column.contents[counter]}  "
      end
      puts "\n"
      counter -= 1
    end
    puts "\n"
  end

  def ask_reset
    input_flag = false
    puts 'Do you want to play again?'
    until input_flag
      print '(y/n): '
      selection = gets.chomp
      if %w[y n Y N].include?(selection)
        input_flag = true
      else
        puts 'PLEASE INPUT Y OR N'
      end
    end
    selection.downcase
  end

  def reset
    @columns = make_columns
  end

  def full_board
    is_full = true
    @columns.each do |column|
      column.check_if_full
      if column.full == false
        is_full = false
      end
    end
    is_full
  end
end

class Column
  attr_accessor :contents, :full
  def initialize
    @contents = Array.new(6, '*')
    @full = false
  end

  def check_if_full
    @full = @contents.include?('*') ? false : true
  end
end

def set_game
  puts 'Who wants to play as black?'
  print 'Name: '
  black = gets.chomp
  puts "\n"
  puts 'Who wants to play as white?'
  print 'Name: '
  white = gets.chomp
  puts "\n"
  Board.new(black, white)
end

def round(board, player)
  board.show
  column = board.ask_for_column(player)
  player == board.black ? board.insert('black', column) : board.insert('white', column)
end

def play
  board = set_game
  continue_playing = 'y'
  until continue_playing == 'n'
    winner = false
    prng = Random.new.rand(2)
    current_player = prng.zero? ? board.black : board.white
    until winner || board.full_board
      round(board, current_player)
      winner = board.check
      current_player = current_player == board.black ? board.white : board.black
    end
    if winner
      winner = current_player == board.black ? board.white : board.black
      puts "#{winner} is the winner! \n"
    else
      puts "There was no winner that time! \n"
    end
    if board.ask_reset == 'y'
      board.reset
    else
      continue_playing = 'n'
      puts 'Goodbye!'
    end
    puts "\n"
  end
end

play
