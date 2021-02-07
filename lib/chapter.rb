class ChapterParser
  attr_reader :verses

  def initialize(verses)
    @verses = verses
  end

  def to_json(*options)
    { 'verses' => @verses }.to_json(*options)
  end

  def self.from_hash(hash)
    verses = []
    hash['verses'].each { |v| verses.append(VerseParser.from_hash(v)) }
    return ChapterParser.new(verses)
  end
end
