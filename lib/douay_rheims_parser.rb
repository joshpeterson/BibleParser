# This script parses the text of the Douay-Rheims bible translation
# from Project Guntenberg. It expects a file named translations/douay-rheims.txt
# from the current directory and it produces a file named translations/douay-rheims.json.
#
# Run it like this:
# ruby douay_rheims_parser.rb

require_relative "bible.rb"
require_relative "book.rb"
require_relative "chapter.rb"
require_relative "verse.rb"
require_relative "validate.rb"

class DouayRheimsParser
  def parse(input_file:, output_file:)
    bible = Bible.new("Douay-Rheims", [])

    started = false
    parsing_verse = false
    current_verse = ""

    File.foreach(input_file) do |line|
      line = line.strip()

      # Check for the start or end of parsing
      break if started and end_of_bible_text?(line)
      started = true if not started and start_of_bible_text?(line)

      if started
        # Each verse can span multiple lines, so handle verse parsing separately.
        if not parsing_verse
          if book_name?(line)
            bible.books.append(Book.new(line, []))
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
            current_verse = ""
            parsing_verse = false
          else
            current_verse += " " if not current_verse.empty?
            current_verse += line
          end
        end
      end
    end

    validate(bible, number_of_books: 74)

    File.write(output_file, JSON.pretty_generate(bible))
  end

  def book_name?(possible_name)
    return (not possible_name.empty? and
            possible_name.match(/^[A-Z ,']*$/) or
            possible_name.include?(" OF ST. ") or
            possible_name.include?(" TO ST. ") and
            not possible_name.include?("NEW TESTAMENT"))
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
    verse[verse.index(".") + 2..-1]
  end

  def start_of_bible_text?(line)
    line == "THE BOOK OF GENESIS"
  end

  def end_of_bible_text?(line)
    line == "APPENDICES"
  end
end

# Actually parse the input text only when the script is called directly
# (not during unit tests).
if __FILE__ == $0
  parser = DouayRheimsParser.new
  parser.parse(input_file: "translations/douay-rheims.txt",
               output_file: "translations/douay-rheims.json")
end
