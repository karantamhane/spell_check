require '~/Desktop/hs/random/spell_check/spell_check'
word_freq = get_freq 'big.txt'
Shoes.app do
  background "#FFFFFF"
  stack margin_top: 20, margin_left: 20 do
    para "Enter word:"
    @word = edit_line
  end
  stack margin_left: 20, margin_bottom: 20 do
    button("Check Spelling") do
      @f = flow margin_left: 20 do
        @f.clear if @f
        @s = suggestions(@word.text, word_freq)
        if @s.kind_of? String
          para "\"#{@word.text}\" is already a valid word!"
        else
          para "Closest matches for \"#{@word.text}\" : "
          @s.each do |word|
            if word == @s.last
              para word + '.'
            else
              para word + ', '
            end
          end
        end
      end
    end
  end
end