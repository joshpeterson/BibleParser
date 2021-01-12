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
    if not valid_book_name?(book.title)
      raise "Book at index #{i} does not have a valid title: '#{book.title}'"
    end
    raise "Book at index #{i} does not have any chapters" if book.chapters.empty?
    book.chapters.each_with_index do |chapter, j|
      if chapter.verses.empty?
        raise "Book at index #{index}, chapter at index #{j} does not have any verses."
      end
    end
  end
end

def valid_book_name?(name)
  [
    "Genesis",
    "Exodus",
    "Leviticus",
    "Numbers",
    "Deuteronomy",
    "Joshua",
    "Judges",
    "Ruth",
    "1 Samuel",
    "2 Samuel",
    "1 Kings",
    "2 Kings",
    "1 Chronicles",
    "2 Chronicles",
    "Ezra",
    "Nehemiah",
    "Tobit",
    "Judith",
    "Esther",
    "1 Maccabees",
    "2 Maccabees",
    "Job",
    "Psalms",
    "Proverbs",
    "Ecclesiastes",
    "Song of Songs",
    "Wisdom",
    "Ecclesiasticus",
    "Isaiah",
    "Jeremiah",
    "Lamentations",
    "Baruch",
    "Ezekiel",
    "Daniel",
    "Hosea",
    "Joel",
    "Amos",
    "Obadiah",
    "Jonah",
    "Micah",
    "Nahum",
    "Habakkuk",
    "Zephaniah",
    "Haggai",
    "Zechariah",
    "Malachi",
    "Matthew",
    "Mark",
    "Luke",
    "John",
    "Acts of the Apostles",
    "Romans",
    "1 Corinthians",
    "2 Corinthians",
    "Galatians",
    "Ephesians",
    "Philippians",
    "Colossians",
    "1 Thessalonians",
    "2 Thessalonians",
    "1 Timothy",
    "2 Timothy",
    "Titus",
    "Philemon",
    "Hebrews",
    "James",
    "1 Peter",
    "2 Peter",
    "1 John",
    "2 John",
    "3 John",
    "Jude",
    "Revelation",
  ].include?(name)
end
