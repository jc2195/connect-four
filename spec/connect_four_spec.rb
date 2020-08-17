# spec/connect_four_spec.rb

require './lib/connect_four'

describe Column do
  describe '#check_if_full' do
    it 'returns false if column is empty' do
      column = Column.new
      expect(column.check_if_full).to eql(false)
    end

    it 'returns false if column is partially full' do
      column = Column.new
      column.contents = [1, 2, 3, 4, '*', '*']
      expect(column.check_if_full).to eql(false)
    end

    it 'returns true if column is full' do
      column = Column.new
      column.contents = [1, 2, 3, 4, 5, 6]
      expect(column.check_if_full).to eql(true)
    end
  end
end

describe Board do
  describe '#make_columns' do
    it 'returns an array' do
      board = Board.new('black', 'white')
      expect(board.make_columns.is_a?(Array)).to eql(true)
    end

    it 'returned array is of length 7' do
      board = Board.new('black', 'white')
      expect(board.make_columns.length).to eql(7)
    end

    it 'sets each value of the returned array to a column class' do
      board = Board.new('black', 'white')
      board.make_columns.each do |element|
        expect(element.is_a?(Column)).to eql(true)
      end
    end
  end

  describe '#insert' do
    it 'inserts the correct value into the correct place in column if column is empty' do
      board = Board.new('black', 'white')
      board.insert('black', 4)
      expect(board.columns[4].contents).to eql(['B', '*', '*', '*', '*', '*'])
    end

    it 'inserts the correct value into the correct place in column if column is partially full' do
      board = Board.new('black', 'white')
      board.columns[2].contents = ['B', 'B', 'B', '*', '*', '*']
      board.insert('white', 2)
      expect(board.columns[2].contents).to eql(['B', 'B', 'B', 'W', '*', '*'])
    end
  end

  describe '#check' do
    it 'returns false if board is empty' do
      board = Board.new('black', 'white')
      expect(board.check).to eql(false)
    end

    it 'returns false if there is no winner' do
      board = Board.new('black', 'white')
      board.columns[1].contents = ['B', '*', '*', '*', '*', '*']
      board.columns[2].contents = ['B', 'W', 'B', '*', '*', '*']
      board.columns[3].contents = ['W', 'W', 'W', '*', '*', '*']
      board.columns[4].contents = ['W', 'B', 'W', 'B', 'B', '*']
      board.columns[5].contents = ['B', 'W', 'B', 'W', '*', '*']
      board.columns[6].contents = ['B', 'W', 'B', '*', '*', '*']
      expect(board.check).to eql(false)
    end

    it 'returns true if there is a diagonal winner' do
      board = Board.new('black', 'white')
      board.columns[1].contents = ['B', '*', '*', '*', '*', '*']
      board.columns[2].contents = ['W', 'W', 'B', '*', '*', '*']
      board.columns[3].contents = ['W', 'W', 'W', '*', '*', '*']
      board.columns[4].contents = ['W', 'B', 'W', 'B', 'B', '*']
      board.columns[5].contents = ['B', 'W', 'B', 'W', '*', '*']
      board.columns[6].contents = ['B', 'W', 'B', '*', '*', '*']
      expect(board.check).to eql(true)
    end

    it 'returns true if there is a vertical winner' do
      board = Board.new('black', 'white')
      board.columns[1].contents = ['B', '*', '*', '*', '*', '*']
      board.columns[2].contents = ['B', 'W', 'B', '*', '*', '*']
      board.columns[3].contents = ['W', 'W', 'W', '*', '*', '*']
      board.columns[4].contents = ['W', 'B', 'B', 'B', 'B', '*']
      board.columns[5].contents = ['B', 'W', 'B', 'W', '*', '*']
      board.columns[6].contents = ['B', 'W', 'W', '*', '*', '*']
      expect(board.check).to eql(true)
    end

    it 'returns true if there is a horizontal winner' do
      board = Board.new('black', 'white')
      board.columns[1].contents = ['B', '*', '*', '*', '*', '*']
      board.columns[2].contents = ['B', 'W', 'B', '*', '*', '*']
      board.columns[3].contents = ['W', 'W', 'W', '*', '*', '*']
      board.columns[4].contents = ['W', 'B', 'W', 'B', 'B', '*']
      board.columns[5].contents = ['B', 'W', 'W', 'W', '*', '*']
      board.columns[6].contents = ['B', 'B', 'W', '*', '*', '*']
      expect(board.check).to eql(true)
    end
  end

  describe '#reset' do
    board = Board.new('black', 'white')
    board.columns[1].contents = ['B', '*', '*', '*', '*', '*']
    board.columns[2].contents = ['B', 'W', 'B', '*', '*', '*']
    board.columns[3].contents = ['W', 'W', 'W', '*', '*', '*']
    board.columns[4].contents = ['W', 'B', 'W', 'B', 'B', '*']
    board.columns[5].contents = ['B', 'W', 'W', 'W', '*', '*']
    board.columns[6].contents = ['B', 'B', 'W', '*', '*', '*']
    board.reset

    it 'leaves the names as they were before' do
      expect(board.black).to eql('black')
      expect(board.white).to eql('white')
    end

    it 'resets the columns to blanks' do
      board.columns.each do |column|
        expect(column.contents).to eql(['*', '*', '*', '*', '*', '*'])
      end
    end
  end

  describe '#full_board' do
    it 'returns true if the entire board is full' do
      board = Board.new('black', 'white')
      board.columns[0].contents = ['W', 'B', 'W', 'B', 'B', 'W']
      board.columns[1].contents = ['W', 'B', 'W', 'B', 'B', 'W']
      board.columns[2].contents = ['W', 'B', 'W', 'B', 'B', 'W']
      board.columns[3].contents = ['W', 'B', 'W', 'B', 'B', 'W']
      board.columns[4].contents = ['W', 'B', 'W', 'B', 'B', 'W']
      board.columns[5].contents = ['W', 'B', 'W', 'B', 'B', 'W']
      board.columns[6].contents = ['W', 'B', 'W', 'B', 'B', 'W']
      expect(board.full_board).to eql(true)
    end

    it 'returns false if the entire board is not full' do
      board = Board.new('black', 'white')
      expect(board.full_board).to eql(false)
    end
  end
end