class BookParser
  attr_reader :title
  attr_reader :chapters

  def initialize(title, chapters)
    @title = title
    @chapters = chapters
  end

  def to_json(*options)
    { 'title' => @title, 'chapters' => @chapters }.to_json(*options)
  end

  def self.from_hash(hash)
    chapters = []
    hash['chapters'].each { |c| chapters.append(ChapterParser.from_hash(c)) }
    return BookParser.new(hash['title'], chapters)
  end
end
