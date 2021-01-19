class Chapter
  attr_reader :verses

  def initialize(verses)
    @verses = verses
  end

  def to_json(*options)
    { 'verses' => @verses }.to_json(*options)
  end

  def self.from_hash(hash)
    verses = []
    hash['verses'].each { |v| verses.append(Verse.from_hash(v)) }
    return Chapter.new(verses)
  end
end
