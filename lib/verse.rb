require 'json'

class VerseParser
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def to_json(*options)
    { 'text' => @text }.to_json(*options)
  end

  def self.from_hash(hash)
    VerseParser.new(hash['text'])
  end
end
