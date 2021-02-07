require_relative 'bible.rb'
require_relative 'book.rb'
require_relative 'chapter.rb'
require_relative 'verse.rb'

def load(translation_name)
  bible_text =
    File.open(
      "external/BibleParser/translations/#{translation_name}.json",
      'rb',
      &:read
    )
  BibleParser.from_hash(JSON.parse(bible_text))
end
