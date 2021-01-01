require "minitest/autorun"
require "json"
require_relative "../lib/verse"

class VerseTest < Minitest::Test
  def test_to_json
    verse = Verse.new("Test verse content")
    json = JSON.generate(verse)
    assert_equal json, "{\"text\":\"Test verse content\"}"
  end
end
