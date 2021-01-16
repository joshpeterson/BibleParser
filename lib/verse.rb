require 'json'

class Verse
  def initialize(text)
    @text = text
  end

  def to_json(*options)
    { 'text' => @text }.to_json(*options)
  end
end
