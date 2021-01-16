class Chapter
  attr_reader :verses

  def initialize(verses)
    @verses = verses
  end

  def to_json(*options)
    { 'verses' => @verses }.to_json(*options)
  end
end
