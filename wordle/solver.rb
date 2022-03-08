module Wordle
  class Solver
    FIRST_GUESS = 'aisle'.freeze

    attr_reader :game
    attr_accessor :guessed_words

    def initialize(game)
      @game = game
      @guessed_words = []
    end

    def solve
      word_to_guess = FIRST_GUESS

      included_positional_tokens = {}
      excluded_positional_tokens = {}
      included_tokens = []
      excluded_tokens = []

      while(true)
        clues = game.guess(word_to_guess)

        pp word_to_guess
        pp clues

        game_won = true

        clues.each_with_index do |clue, idx|
          if clue == "🟩"
            included_positional_tokens[idx] = word_to_guess[idx]
          elsif clue == "🟨"
            game_won = false
            included_tokens << word_to_guess[idx]

            if excluded_positional_tokens[idx].nil?
              excluded_positional_tokens[idx] = []
            end

            excluded_positional_tokens[idx] << word_to_guess[idx]
          elsif clue == "🟥"
            # will handle in next loop
          else
            raise StandardError, "Something went wrong"
          end
        end

        clues.each_with_index do |clue, idx|
          next unless clue == "🟥"

          if !included_positional_tokens.values.include?(word_to_guess[idx])
            excluded_tokens << word_to_guess[idx]
          end

          game_won = false
        end


        if game_won
          puts "🎉🎉🎉🎉🎉🎉🎉🎉"
          return
        end

        word_to_guess = Dictionary.search(
          included_positional_tokens: included_positional_tokens,
          included_tokens: included_tokens,
          excluded_tokens: excluded_tokens,
        )

        if word_to_guess.nil?
          puts "We couldn't find the word!"
          return
        end
      end

    rescue Game::OutOfAttemptsError
      puts "We ran out of attempts."
    end
  end
end