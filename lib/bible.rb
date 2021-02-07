class BibleParser
  attr_reader :name
  attr_reader :books

  def initialize(name, books)
    @name = name
    @books = books
  end

  def to_json(*options)
    { 'name' => @name, 'books' => @books }.to_json(*options)
  end

  def self.from_hash(hash)
    books = []
    hash['books'].each { |b| books.append(BookParser.from_hash(b)) }
    return BibleParser.new(hash['name'], books)
  end
end
