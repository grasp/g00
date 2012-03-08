# coding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.


def load_habit_word
      $habit_word=Hash.new
      $habit_word_reverse=Hash.new
        filename=File.dirname(__FILE__)+File::SEPARATOR+"habit_words.txt"
      open(filename).each do |line|
        if line.size >0
          user=line.force_encoding("utf-8").split(/\s/)
          unless user[1].nil?
          $habit_word[user[0]]=user[1].force_encoding("utf-8") 
          $habit_word_reverse[user[1].force_encoding("utf-8")]=user[0]
         end
      end
  end
end

load_habit_word



