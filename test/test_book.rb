require 'minitest/autorun'
require 'json'
require_relative '../lib/verse'
require_relative '../lib/chapter'
require_relative '../lib/book'

class BookTest < Minitest::Test
  def test_to_json
    verses = [
      VerseParser.new('Test verse 1 content'),
      VerseParser.new('Test verse 2 content')
    ]
    verses2 = [
      VerseParser.new('Test verse 3 content'),
      VerseParser.new('Test verse 4 content')
    ]
    chapters = [ChapterParser.new(verses), ChapterParser.new(verses2)]
    book = BookParser.new('Test Title', chapters)
    json = JSON.generate(book)
    assert_equal json,
                 "{\"title\":\"Test Title\"," \
                   "\"chapters\":[" \
                   "{\"verses\":[" \
                   "{\"text\":\"Test verse 1 content\"}," \
                   "{\"text\":\"Test verse 2 content\"}" \
                   ']},' \
                   "{\"verses\":[" \
                   "{\"text\":\"Test verse 3 content\"}," \
                   "{\"text\":\"Test verse 4 content\"}" \
                   ']}' \
                   ']}'
  end

  def test_from_json
    book =
      BookParser.from_hash(
        JSON.parse(
          "{\"title\":\"Test Title\"," \
            "\"chapters\":[" \
            "{\"verses\":[" \
            "{\"text\":\"Test verse 1 content\"}," \
            "{\"text\":\"Test verse 2 content\"}" \
            ']},' \
            "{\"verses\":[" \
            "{\"text\":\"Test verse 3 content\"}," \
            "{\"text\":\"Test verse 4 content\"}" \
            ']}' \
            ']}'
        )
      )
    assert_equal 'Test Title', book.title
    assert_equal 2, book.chapters.length
    assert_equal 'Test verse 1 content', book.chapters[0].verses[0].text
    assert_equal 'Test verse 2 content', book.chapters[0].verses[1].text
    assert_equal 'Test verse 3 content', book.chapters[1].verses[0].text
    assert_equal 'Test verse 4 content', book.chapters[1].verses[1].text
  end
end
