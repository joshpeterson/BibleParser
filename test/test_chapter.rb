require 'minitest/autorun'
require 'json'
require_relative '../lib/verse'
require_relative '../lib/chapter'

class ChapterTest < Minitest::Test
  def test_to_json
    verses = [
      Verse.new('Test verse 1 content'),
      Verse.new('Test verse 2 content')
    ]
    chapter = Chapter.new(verses)
    json = JSON.generate(chapter)
    assert_equal json,
                 "{\"verses\":" \
                   "[{\"text\":\"Test verse 1 content\"}," \
                   "{\"text\":\"Test verse 2 content\"}]}"
  end

  def test_from_json
    chapter =
      Chapter.from_hash(
        JSON.parse(
          "{\"verses\":" \
            "[{\"text\":\"Test verse 1 content\"}," \
            "{\"text\":\"Test verse 2 content\"}]}"
        )
      )
    assert_equal 2, chapter.verses.length
    assert_equal 'Test verse 1 content', chapter.verses[0].text
    assert_equal 'Test verse 2 content', chapter.verses[1].text
  end
end
