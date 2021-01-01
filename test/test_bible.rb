require "minitest/autorun"
require "json"
require_relative "../lib/verse"
require_relative "../lib/chapter"
require_relative "../lib/book"
require_relative "../lib/bible"

class BibleTest < Minitest::Test
  def test_to_json
    verses = [Verse.new("Test verse 1 content"), Verse.new("Test verse 2 content")]
    verses2 = [Verse.new("Test verse 3 content"), Verse.new("Test verse 4 content")]
    chapters = [Chapter.new(verses), Chapter.new(verses2)]
    books = [Book.new("Test Title", chapters), Book.new("Test Title 2", chapters)]
    bible = Bible.new("Test Translation Name", books)
    json = JSON.generate(bible)
    assert_equal json, "{\"name\":\"Test Translation Name\"," \
                 "\"books\":[" \
                 "{\"title\":\"Test Title\"," \
                 "\"chapters\":[" \
                 "{\"verses\":[" \
                 "{\"text\":\"Test verse 1 content\"},{\"text\":\"Test verse 2 content\"}" \
                 "]}," \
                 "{\"verses\":[" \
                 "{\"text\":\"Test verse 3 content\"},{\"text\":\"Test verse 4 content\"}" \
                 "]}" \
                 "]}," \
                 "{\"title\":\"Test Title 2\"," \
                 "\"chapters\":[" \
                 "{\"verses\":[" \
                 "{\"text\":\"Test verse 1 content\"},{\"text\":\"Test verse 2 content\"}" \
                 "]}," \
                 "{\"verses\":[" \
                 "{\"text\":\"Test verse 3 content\"},{\"text\":\"Test verse 4 content\"}" \
                 "]}" \
                 "]}" \
                 "]}"
  end
end
