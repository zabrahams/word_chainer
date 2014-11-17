require 'set'

class WordChainer

  LETTERS = ("a".."z").to_a

  def initialize(dictionary_file_name)
    @dictionary = File.readlines(dictionary_file_name).map(&:chomp)
    @dictionary = @dictionary.to_set
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = { source => nil }

    until @current_words.empty?
      explore_current_words
    end
  end

  def explore_current_words
    current_word = @current_words.shift
    new_words = adjacent_words(current_word)

    new_words.each do |new_word|
      unless @all_seen_words.has_key?(new_word)
        @current_words << new_word
        @all_seen_words[new_word] = current_word
        puts "#{@all_seen_words[new_word]} => #{new_word}"
      end
    end
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
