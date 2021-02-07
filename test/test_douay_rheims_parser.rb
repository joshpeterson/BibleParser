require 'minitest/autorun'
require_relative '../lib/douay_rheims_parser.rb'

class DouayRheimsParserTest < Minitest::Test
  def setup
    @parser = DouayRheimsParser.new
  end

  def test_book_name
    assert @parser.book_name?('THE GOSPEL OF JOHN')
  end

  def test_book_name_for_one_word
    assert @parser.book_name?('ECCLESIASTICUS')
  end

  def test_book_name_for_name_with_comma
    assert @parser.book_name?(
             'THE FIRST BOOK OF SAMUEL, OTHERWISE CALLED THE FIRST BOOK OF KINGS'
           )
  end

  def test_book_name_for_name_with_period
    assert @parser.book_name?(
             'THE HOLY GOSPEL OF JESUS CHRIST ACCORDING TO ST. MARK'
           )
  end

  def test_book_name_for_name_with_apostrophe
    assert @parser.book_name?("SOLOMON'S CANTICLE OF CANTICLES")
  end

  def test_book_name_false_for_book_name_not_all_caps
    assert !@parser.book_name?('The GOSPEL OF JOHN')
  end

  def test_book_name_false_for_empty_string
    assert !@parser.book_name?('')
  end

  def test_book_name_false_for_all_caps_with_period
    assert !@parser.book_name?('WAS THE WORD.')
  end

  def test_chapter_name
    assert @parser.chapter_name?('Canticle of Canticles ChapterParser 1')
  end

  def test_chapter_name_with_zero
    assert @parser.chapter_name?('Canticle of Canticles ChapterParser 10')
  end

  def test_start_of_verse
    assert @parser.start_of_verse?('23:8. And he gathered together all the')
  end

  def test_start_of_verse_with_zero
    assert @parser.start_of_verse?(
             '30:1. Now when all these things shall be come upon thee'
           )
  end

  def test_end_of_verse
    assert @parser.end_of_verse?('')
  end

  def test_strip_verse_number
    assert_equal 'And he gathered together all the',
                 @parser.strip_verse_number(
                   '23:8. And he gathered together all the'
                 )
  end
end
