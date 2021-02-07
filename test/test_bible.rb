require 'minitest/autorun'
require 'json'
require_relative '../lib/verse'
require_relative '../lib/chapter'
require_relative '../lib/book'
require_relative '../lib/bible'

class BibleTest < Minitest::Test
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
    books = [
      BookParser.new('Test Title', chapters),
      BookParser.new('Test Title 2', chapters)
    ]
    bible = BibleParser.new('Test Translation Name', books)
    json = JSON.generate(bible)
    assert_equal json,
                 "{\"name\":\"Test Translation Name\"," \
                   "\"books\":[" \
                   "{\"title\":\"Test Title\"," \
                   "\"chapters\":[" \
                   "{\"verses\":[" \
                   "{\"text\":\"Test verse 1 content\"},{\"text\":\"Test verse 2 content\"}" \
                   ']},' \
                   "{\"verses\":[" \
                   "{\"text\":\"Test verse 3 content\"},{\"text\":\"Test verse 4 content\"}" \
                   ']}' \
                   ']},' \
                   "{\"title\":\"Test Title 2\"," \
                   "\"chapters\":[" \
                   "{\"verses\":[" \
                   "{\"text\":\"Test verse 1 content\"},{\"text\":\"Test verse 2 content\"}" \
                   ']},' \
                   "{\"verses\":[" \
                   "{\"text\":\"Test verse 3 content\"},{\"text\":\"Test verse 4 content\"}" \
                   ']}' \
                   ']}' \
                   ']}'
  end

  def test_from_json
    bible =
      BibleParser.from_hash(
        JSON.parse(
          "{\"name\":\"Test Translation Name\"," \
            "\"books\":[" \
            "{\"title\":\"Test Title\"," \
            "\"chapters\":[" \
            "{\"verses\":[" \
            "{\"text\":\"Test verse 1 content\"},{\"text\":\"Test verse 2 content\"}" \
            ']},' \
            "{\"verses\":[" \
            "{\"text\":\"Test verse 3 content\"},{\"text\":\"Test verse 4 content\"}" \
            ']}' \
            ']},' \
            "{\"title\":\"Test Title 2\"," \
            "\"chapters\":[" \
            "{\"verses\":[" \
            "{\"text\":\"Test verse 1 content\"},{\"text\":\"Test verse 2 content\"}" \
            ']},' \
            "{\"verses\":[" \
            "{\"text\":\"Test verse 3 content\"},{\"text\":\"Test verse 4 content\"}" \
            ']}' \
            ']}' \
            ']}'
        )
      )

    assert_equal 'Test Translation Name', bible.name
    assert_equal 2, bible.books.length
    assert_equal 'Test Title', bible.books[0].title
    assert_equal 2, bible.books[0].chapters.length
    assert_equal 'Test verse 1 content',
                 bible.books[0].chapters[0].verses[0].text
    assert_equal 'Test verse 2 content',
                 bible.books[0].chapters[0].verses[1].text
    assert_equal 'Test verse 3 content',
                 bible.books[0].chapters[1].verses[0].text
    assert_equal 'Test verse 4 content',
                 bible.books[0].chapters[1].verses[1].text
    assert_equal 'Test Title 2', bible.books[1].title
    assert_equal 2, bible.books[1].chapters.length
    assert_equal 'Test verse 1 content',
                 bible.books[1].chapters[0].verses[0].text
    assert_equal 'Test verse 2 content',
                 bible.books[1].chapters[0].verses[1].text
    assert_equal 'Test verse 3 content',
                 bible.books[1].chapters[1].verses[0].text
    assert_equal 'Test verse 4 content',
                 bible.books[1].chapters[1].verses[1].text
  end
end
