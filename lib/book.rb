class Book
  attr_reader :title
  attr_reader :chapters

  def initialize(title, chapters)
    @title = title
    @chapters = chapters
  end

  def to_json(*options)
    { "title" => @title, "chapters" => @chapters }.to_json(*options)
  end
end
