module Wordle
  class Game
    attr_reader :word_tokens
    attr_accessor :attempts

    NUM_ATTEMPTS = 6

    class OutOfAttemptsError < StandardError; end

    def initialize(word)
      @word_tokens = word.split('')
      @attempts = NUM_ATTEMPTS
    end

    def guess(guessed_word)
      if self.attempts == 0
        raise OutOfAttemptsError
      end

      self.attempts -= 1

      clues = []
      letters_in_correct_position = []

      guessed_word.split('').each_with_index do |guessed_word_letter, idx|
        if guessed_word_letter == self.word_tokens[idx]
          clues << "🟩"
          letters_in_correct_position << guessed_word_letter
        # TODO: Optimize
        elsif self.word_tokens.include?(guessed_word_letter)
          clues << "🟨"
        else
          clues << "🟥"
        end
      end

      remaining_letters = self.word_tokens - letters_in_correct_position

      clues.each_with_index do |clue, idx|
        next unless clue == "🟨"

        unless remaining_letters.include?(guessed_word[idx])
          clues[idx] = "🟥"
        end
      end

      clues
    end
  end
end