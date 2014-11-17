require 'set'

class WordChainer

  LETTERS = ("a".."z").to_a

  attr_reader :dictionary

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

    path = build_path(target)
    print_path(path)

  end

  def explore_current_words
    current_word = @current_words.shift
    new_words = adjacent_words(current_word)

    new_words.each do |new_word|
      unless @all_seen_words.has_key?(new_word)
        @current_words << new_word
        @all_seen_words[new_word] = current_word
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

  def build_path(target)
    path = []
    current_word = target

    until current_word == nil
      path.unshift(current_word)
      current_word = @all_seen_words[current_word]
    end

    path
  end


  def print_path(path)
    puts "No path found!" if path.count == 1

    path.drop(1).each do |word|
      puts "#{@all_seen_words[word]} => #{word}"
    end
  end

end

def get_valid_word(dictionary)
  begin
    word = gets.chomp.downcase
    raise "Input not in dictionary" unless dictionary.include?(word)
  rescue
    puts "Input not found in dictionary. Please input a real word."
    retry
  end
  word
end

if $PROGRAM_NAME == __FILE__
  word_chainer = WordChainer.new("dictionary.txt")
  puts "Welcome to Word Chainer"

  puts "Please input a source word."
  source = get_valid_word(word_chainer.dictionary)
  puts "Please input a target word."
  target = get_valid_word(word_chainer.dictionary)

  word_chainer.run(source, target)
end
