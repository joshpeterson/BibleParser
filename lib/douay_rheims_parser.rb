# This script parses the text of the Douay-Rheims bible translation
# from Project Guntenberg. It expects a file named translations/douay-rheims.txt
# from the current directory and it produces a file named translations/douay-rheims.json.
#
# Run it like this:
# ruby douay_rheims_parser.rb

require_relative 'bible.rb'
require_relative 'book.rb'
require_relative 'chapter.rb'
require_relative 'verse.rb'
require_relative 'validate.rb'

class DouayRheimsParser
  def parse(input_file:, output_file:)
    bible = Bible.new('Douay-Rheims', [])

    started = false
    parsing_verse = false
    current_verse = ''

    File.foreach(input_file) do |line|
      line = line.strip

      # Check for the start or end of parsing
      break if started and end_of_bible_text?(line)
      started = true if not started and start_of_bible_text?(line)

      if started
        # Each verse can span multiple lines, so handle verse parsing separately.
        if not parsing_verse
          if book_name?(line)
            bible.books.append(Book.new(fix_book_name(line), []))
          elsif chapter_name?(line)
            bible.books.last.chapters.append(Chapter.new([]))
          elsif start_of_verse?(line)
            parsing_verse = true
          end
        end

        if parsing_verse
          if end_of_verse?(line)
            bible.books.last.chapters.last.verses.append(
              Verse.new(strip_verse_number(current_verse))
            )
            current_verse = ''
            parsing_verse = false
          else
            current_verse += ' ' if not current_verse.empty?
            current_verse += line
          end
        end
      end
    end

    validate(bible, number_of_books: 73)

    File.write(output_file, JSON.pretty_generate(bible))
  end

  def book_name?(possible_name)
    return(
      not possible_name.empty? and possible_name.match(/^[A-Z ,']*$/) or
        possible_name.include?(' OF ST. ') or
        possible_name.include?(' TO ST. ') and
        not possible_name.include?('NEW TESTAMENT') and
        not possible_name == 'THE PRAYER OF JEREMIAS THE PROPHET'
    )
  end

  def chapter_name?(possible_name)
    possible_name.match(/^.* Chapter [1-9]*/)
  end

  def start_of_verse?(possible_verse)
    possible_verse.match(/^[0-9]+:[0-9]+. /)
  end

  def end_of_verse?(possible_verse)
    possible_verse.empty?
  end

  def strip_verse_number(verse)
    verse[verse.index('.') + 2..-1]
  end

  def start_of_bible_text?(line)
    line == 'THE BOOK OF GENESIS'
  end

  def end_of_bible_text?(line)
    line == 'APPENDICES'
  end

  def fix_book_name(name)
    @@fixed_book_names[name] || name
  end

  @@fixed_book_names = {
    'THE BOOK OF GENESIS' => 'Genesis',
    'THE BOOK OF EXODUS' => 'Exodus',
    'THE BOOK OF LEVITICUS' => 'Leviticus',
    'THE BOOK OF NUMBERS' => 'Numbers',
    'THE BOOK OF DEUTERONOMY' => 'Deuteronomy',
    'THE BOOK OF JOSUE' => 'Joshua',
    'THE BOOK OF JUDGES' => 'Judges',
    'THE BOOK OF RUTH' => 'Ruth',
    'THE FIRST BOOK OF SAMUEL, OTHERWISE CALLED THE FIRST BOOK OF KINGS' =>
      '1 Samuel',
    'THE SECOND BOOK OF SAMUEL, OTHERWISE CALLED THE SECOND BOOK OF KINGS' =>
      '2 Samuel',
    'THE THIRD BOOK OF KINGS' => '1 Kings',
    'THE FOURTH BOOK OF KINGS' => '2 Kings',
    'THE FIRST BOOK OF PARALIPOMENON' => '1 Chronicles',
    'THE SECOND BOOK OF PARALIPOMENON' => '2 Chronicles',
    'THE FIRST BOOK OF ESDRAS' => 'Ezra',
    'THE BOOK OF NEHEMIAS, WHICH IS CALLED THE SECOND OF ESDRAS' => 'Nehemiah',
    'THE BOOK OF TOBIAS' => 'Tobit',
    'THE BOOK OF JUDITH' => 'Judith',
    'THE BOOK OF ESTHER' => 'Esther',
    'THE BOOK OF JOB' => 'Job',
    'THE BOOK OF PSALMS' => 'Psalms',
    'THE BOOK OF PROVERBS' => 'Proverbs',
    'ECCLESIASTES' => 'Ecclesiastes',
    "SOLOMON'S CANTICLE OF CANTICLES" => 'Song of Songs',
    'THE BOOK OF WISDOM' => 'Wisdom',
    'ECCLESIASTICUS' => 'Ecclesiasticus',
    'THE PROPHECY OF ISAIAS' => 'Isaiah',
    'THE PROPHECY OF JEREMIAS' => 'Jeremiah',
    'THE LAMENTATIONS OF JEREMIAS' => 'Lamentations',
    'THE PROPHECY OF BARUCH' => 'Baruch',
    'THE PROPHECY OF EZECHIEL' => 'Ezekiel',
    'THE PROPHECY OF DANIEL' => 'Daniel',
    'THE PROPHECY OF OSEE' => 'Hosea',
    'THE PROPHECY OF JOEL' => 'Joel',
    'THE PROPHECY OF AMOS' => 'Amos',
    'THE PROPHECY OF ABDIAS' => 'Obadiah',
    'THE PROPHECY OF JONAS' => 'Jonah',
    'THE PROPHECY OF MICHEAS' => 'Micah',
    'THE PROPHECY OF NAHUM' => 'Nahum',
    'THE PROPHECY OF HABACUC' => 'Habakkuk',
    'THE PROPHECY OF SOPHONIAS' => 'Zephaniah',
    'THE PROPHECY OF AGGEUS' => 'Haggai',
    'THE PROPHECY OF ZACHARIAS' => 'Zechariah',
    'THE PROPHECY OF MALACHIAS' => 'Malachi',
    'THE FIRST BOOK OF MACHABEES' => '1 Maccabees',
    'THE SECOND BOOK OF MACHABEES' => '2 Maccabees',
    'THE HOLY GOSPEL OF JESUS CHRIST ACCORDING TO SAINT MATTHEW' => 'Matthew',
    'THE HOLY GOSPEL OF JESUS CHRIST ACCORDING TO ST. MARK' => 'Mark',
    'THE HOLY GOSPEL OF JESUS CHRIST ACCORDING TO ST. LUKE' => 'Luke',
    'THE HOLY GOSPEL OF JESUS CHRIST ACCORDING TO ST. JOHN' => 'John',
    'THE ACTS OF THE APOSTLES' => 'Acts of the Apostles',
    'THE EPISTLE OF ST. PAUL THE APOSTLE TO THE ROMANS' => 'Romans',
    'THE FIRST EPISTLE OF ST. PAUL TO THE CORINTHIANS' => '1 Corinthians',
    'THE SECOND EPISTLE OF ST. PAUL TO THE CORINTHIANS' => '2 Corinthians',
    'THE EPISTLE OF ST. PAUL TO THE GALATIANS' => 'Galatians',
    'THE EPISTLE OF ST. PAUL TO THE EPHESIANS' => 'Ephesians',
    'THE EPISTLE OF ST. PAUL TO THE PHILIPPIANS' => 'Philippians',
    'THE EPISTLE OF ST. PAUL TO THE COLOSSIANS' => 'Colossians',
    'THE FIRST EPISTLE OF ST. PAUL TO THE THESSALONIANS' => '1 Thessalonians',
    'THE SECOND EPISTLE OF ST. PAUL TO THE THESSALONIANS' => '2 Thessalonians',
    'THE FIRST EPISTLE OF ST. PAUL TO TIMOTHY' => '1 Timothy',
    'THE SECOND EPISTLE OF ST. PAUL TO TIMOTHY' => '2 Timothy',
    'THE EPISTLE OF ST. PAUL TO TITUS' => 'Titus',
    'THE EPISTLE OF ST. PAUL TO PHILEMON' => 'Philemon',
    'THE EPISTLE OF ST. PAUL TO THE HEBREWS' => 'Hebrews',
    'THE CATHOLIC EPISTLE OF ST. JAMES THE APOSTLE' => 'James',
    'THE FIRST EPISTLE OF ST. PETER THE APOSTLE' => '1 Peter',
    'THE SECOND EPISTLE OF ST. PETER THE APOSTLE' => '2 Peter',
    'THE FIRST EPISTLE OF ST. JOHN THE APOSTLE' => '1 John',
    'THE SECOND EPISTLE OF ST. JOHN THE APOSTLE' => '2 John',
    'THE THIRD EPISTLE OF ST. JOHN THE APOSTLE' => '3 John',
    'THE CATHOLIC EPISTLE OF ST. JUDE' => 'Jude',
    'THE APOCALYPSE OF ST. JOHN THE APOSTLE' => 'Revelation'
  }
end

# Actually parse the input text only when the script is called directly
# (not during unit tests).
if __FILE__ == $0
  parser = DouayRheimsParser.new
  parser.parse(
    input_file: 'translations/douay-rheims.txt',
    output_file: 'translations/douay-rheims.json'
  )
end
