require 'minitest/autorun'
require 'json'
require_relative '../lib/verse'
require_relative '../lib/chapter'
require_relative '../lib/book'

class BookTest < Minitest::Test
  def test_to_json
    verses = [
      Verse.new('Test verse 1 content'),
      Verse.new('Test verse 2 content')
    ]
    verses2 = [
      Verse.new('Test verse 3 content'),
      Verse.new('Test verse 4 content')
    ]
    chapters = [Chapter.new(verses), Chapter.new(verses2)]
    book = Book.new('Test Title', chapters)
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
      Book.from_hash(
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
