require 'minitest/autorun'
require_relative '../lib/king_james_parser.rb'

class KingJamesParserTest < Minitest::Test
  def setup
    @parser = KingJamesParser.new
  end

  def test_book_name
    lines = ['Geneis', '', 'Chapter']
    assert @parser.book_name?(0, lines)
  end

  def test_start_of_verse
    assert @parser.start_of_verse?('1:5 And God called the light Day, and')
  end

  def test_start_of_verse_with_zero
    assert @parser.start_of_verse?(
             '1:10 And God called the dry land Earth; and the'
           )
  end

  def test_get_chapter_from_verse
    assert_equal 1,
                 @parser.get_chapter_from_verse(
                   '1:10 And God called the dry land Earth'
                 )
  end

  def test_end_of_verse
    assert @parser.end_of_verse?('')
  end

  def test_strip_verse_number
    assert_equal 'And God called the dry land Earth',
                 @parser.strip_verse_number(
                   '1:10 And God called the dry land Earth'
                 )
  end
end
