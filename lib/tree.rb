require_relative 'node'

class Tree
  attr_accessor :insert
  attr_reader :root, :count

  def initialize
    @root = Node.new
    @count = 0
  end

  def count
    @count
  end

  def insert(word, node = @root, index = -1)
    node.freq += 1
    index += 1
    unless word[index]
      @root.freq = 0
      if node.valid_word == false
        @count += 1
      end
      node.valid_word = true
      @count
    else
      saved_letter = word[index]
      unless node.children[saved_letter].nil?
        insert(word, node.children[saved_letter], index)
      else
        node.children[saved_letter] = Node.new
        insert(word, node.children[saved_letter], index)
      end
    end
  end

  def select(sub_string, suggestion, node = @root)
    until suggestion.empty?
      check_letter = suggestion.slice!(0, 1)
      node = node.children[check_letter]
    end
    node.weight += 1
  end

  def suggest(word, node = @root)
     word.each_char do |letter|
      node.children.has_key?(letter)
      node = node.children[letter]
    end
    populate_suggest(word, node)
  end

  def populate_suggest(word, node, suggestions = [])
    if node.valid_word == true
      suggestions << [word, node.weight]
    end
    unless node.children.empty?
      node.children.keys.each do | letter |
        # node.valid_word == false
        temp_suggest = word + letter
        node = node.children[letter]
        populate_suggest(temp_suggest, node, suggestions)
      end
    end
  end

  def populate(file)
    words = File.readlines(file)
    words.each do |word|
      word.chomp!
      insert(word)
    end
    @count
  end

  def delete(word, node = @root, index = 0, temp_letter = word[index])
    if node.children[temp_letter].freq == 1 && node.children.count == 1
      node.children = {}
    else
      binding.pry

      index += 1
      temp_letter = word[index]
      delete(word, node.children[temp_letter], index, temp_letter)
    end
  end

end
