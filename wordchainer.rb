require 'set'

class WordChainer

  LETTERS = ("a".."z").to_a

  def initialize(dictionary_file_name)
    @dictionary = File.readlines(dictionary_file_name).map(&:chomp)
    @dictionary = @dictionary.to_set
  end

  def adjacent_words(word)
    adjacent_words = []

    word.length.times do |i|
      LETTERS.each do |letter|
        next if word[i] == letter

        poss_word = word.dup
        poss_word[i] = letter
        adjacent_words << poss_word if @dictionary.include?(poss_word)
      end
    end
    adjacent_words
  end

end
