
def get_text filename
   file = File.open(filename, 'r')
   file.read
end

def get_words filename
  text = get_text filename
  text.scan(/[a-z]+/i)
end

def get_freq filename
  word_hash = {}
  words = get_words filename
  words.each do |word|
    if word_hash.has_key? word.downcase
      word_hash[word.downcase] += 1
    else
      word_hash[word.downcase ] = 1
    end
  end
  word_hash
end

def fragment_word word
  fragments = []
  for i in (0...word.length+1)
    fragments << [word[0, i], word[i, word.length-i]]
  end
  fragments
end

def first_edit word
  fragments = fragment_word word
  deletions, switches, replacements, additions = [], [], [], []
  alphabet = 'abcdefghijklmnopqrstuvwxyz'.split ""
  for word in fragments do
    a, b = word

    b.length > 1? deletions << a + b[1, b.length] : deletions << a
    
    if b.length > 1
      a.length > 1? switches << a[0, a.length-1] + b[0] + a[-1] + b[1, b.length] : switches << b[0] + a + b[1, b.length]
    else
      a.length > 1? switches << a[0, a.length-1] + b + a[-1] : switches << b + a
    end

    for letter in alphabet do
      b.length > 1? replacements << a + letter + b[1, b.length] : replacements << a + letter
    end

    for letter in alphabet do
      additions << a + letter + b
      additions << a + b + letter
    end 
  end
  (deletions + switches + replacements + additions).uniq
end

def second_edit word
  lst = first_edit word
  result = []
  lst.each do |word|
    result += first_edit word
  end
  result.uniq
end


def valid_edits word, word_freq
  valid = []
  first = false
  if word.length < 8
    editted = first_edit word
    first = true
  else 
    editted = second_edit word
  end
  editted.each do |word|
    valid << word if word_freq.include? word
  end
  if first && valid == []
    editted = second_edit word
    editted.each do |word|
      valid << word if word_freq.include? word
    end
  end
  valid
end


def suggestions word, word_freq
  
  return word if word_freq.include? word

  suggestions = valid_edits word, word_freq
  required_suggestions = [10, suggestions.length].min
  suggestions_dict = {}
  suggestions.each do |s|
    suggestions_dict[s] = word_freq[s]
  end
  output = Hash[suggestions_dict.sort_by{|key, value| value}.reverse[0, required_suggestions]]
  output.keys
end

















