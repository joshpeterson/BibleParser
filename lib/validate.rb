require_relative "bible.rb"
require_relative "book.rb"
require_relative "chapter.rb"
require_relative "verse.rb"

def validate(bible, number_of_books:)
  if bible.books.length != number_of_books
    raise "Expected #{number_of_books} books, but found #{bible.books.length}."
  end

  bible.books.each_with_index do |book, i|
    raise "Book at index #{i} does not have a title." if book.title.empty?
    raise "Book at index #{i} does not have any chapters" if book.chapters.empty?
    book.chapters.each_with_index do |chapter, j|
      if chapter.verses.empty?
        raise "Book at index #{index}, chapter at index #{j} does not have any verses."
      end
    end
  end
end
