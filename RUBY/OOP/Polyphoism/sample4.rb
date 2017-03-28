class Book
  def initialize(author, title, genre)
    @author = author
    @title = title
    @genre = genre
  end

  def to_s()
    "著者: #{@author}, 題名: #{@title}, 分野: #{@genre}"
  end
end

ruby3 = Book.new("arton & ruimo", "Ruby 3", "programming")
puts ruby3
