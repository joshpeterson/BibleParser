require 'minitest/autorun'
require 'json'
require_relative '../lib/verse'

class VerseTest < Minitest::Test
  def test_to_json
    verse = VerseParser.new('Test verse content')
    json = JSON.generate(verse)
    assert_equal json, "{\"text\":\"Test verse content\"}"
  end

  def test_from_json
    verse =
      VerseParser.from_hash(JSON.parse("{\"text\":\"Test verse content\"}"))
    assert_equal 'Test verse content', verse.text
  end
end
