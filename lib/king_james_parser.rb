# This script parses the text of the King James Version bible translation
# from Project Guntenberg. It expects a file named translations/king-james.txt
# from the current directory and it produces a file named translations/king-james.json.
#
# Run it like this:
# ruby king_james_parser.rb

require_relative "bible.rb"
require_relative "book.rb"
require_relative "chapter.rb"
require_relative "verse.rb"
require_relative "validate.rb"

class KingJamesParser
  def parse(input_file:, output_file:)
    bible = Bible.new("King James", [])

    started = false

    lines = File.readlines(input_file, chomp: true)
    number_of_lines = lines.length
    index = 0
    current_chapter = 0
    current_verse = ""
    parsing_verse = false

    while index < number_of_lines
      increment = 1

      current_line = lines[index]

      started = true if not started and current_line == "Genesis"
      break if started and current_line.include?("End of Project Gutenberg's The King James Bible")

      if started
        if book_name?(index, lines)
          bible.books.append(Book.new(current_line, []))
          bible.books.last.chapters.append(Chapter.new([]))
          current_chapter = 1
          increment = 3
        elsif start_of_verse?(current_line)
          parsing_verse = true
          this_chapter = get_chapter_from_verse(current_line)
          if this_chapter != current_chapter
            bible.books.last.chapters.append(Chapter.new([]))
            current_chapter = this_chapter
          end
        end

        if parsing_verse
          if end_of_verse?(current_line)
            bible.books.last.chapters.last.verses.append(
              Verse.new(strip_verse_number(current_verse))
            )
            current_verse = ""
            parsing_verse = false
          else
            current_verse += " " if not current_verse.empty?
            current_verse += lines[index]
          end
        end
      end

      index += increment
    end

    validate(bible, number_of_books: 66)

    File.write(output_file, JSON.pretty_generate(bible))
  end

  def book_name?(index, lines)
    if not lines[index].empty? and lines[index + 1].empty? and lines[index + 2] == "Chapter"
      return true
    end
    return false
  end

  def start_of_verse?(possible_verse)
    possible_verse.match(/^[0-9]+:[0-9]+ /)
  end

  def end_of_verse?(possible_verse)
    possible_verse.empty?
  end

  def get_chapter_from_verse(verse)
    verse[0..verse.index(":")].to_i
  end

  def strip_verse_number(verse)
    verse[verse.index(" ") + 1..-1]
  end
end

# Actually parse the input text only when the script is called directly
# (not during unit tests).
if __FILE__ == $0
  parser = KingJamesParser.new
  parser.parse(input_file: "translations/king-james.txt",
               output_file: "translations/king-james.json")
end
