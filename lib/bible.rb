class Bible
  attr_reader :books

  def initialize(name, books)
    @name = name
    @books = books
  end

  def to_json(*options)
    { "name" => @name, "books" => @books }.to_json(*options)
  end
end
