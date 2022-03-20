require './lib/logger'

module Wordle
  class Solver
    FIRST_GUESS = 'races'.freeze

    def solve
      word_to_guess = FIRST_GUESS

      included_positional_tokens = {}
      excluded_positional_tokens = {}
      included_tokens = []
      excluded_tokens = []

      Logger.log_info("Let's start")

      while(true)
        Logger.log_info("Try #{word_to_guess.upcase}")
        Logger.log_info("What was the response?")

        clues = gets.chomp.split("")

        game_won = true

        clues.each_with_index do |clue, idx|
          if clue == "G"
            included_positional_tokens[idx] = word_to_guess[idx]
          elsif clue == "Y"
            game_won = false
            included_tokens << word_to_guess[idx]

            if excluded_positional_tokens[idx].nil?
              excluded_positional_tokens[idx] = []
            end

            excluded_positional_tokens[idx] << word_to_guess[idx]
          elsif clue == "B"
            # will handle in next loop
          else
            raise StandardError, "Something went wrong"
          end
        end

        clues.each_with_index do |clue, idx|
          next unless clue == "B"

          if !included_positional_tokens.values.include?(word_to_guess[idx])
            excluded_tokens << word_to_guess[idx]
          end

          if excluded_positional_tokens[idx].nil?
            excluded_positional_tokens[idx] = []
          end

          excluded_positional_tokens[idx] << word_to_guess[idx]

          game_won = false
        end


        if game_won
          puts 5.times.map { "🎉🎉🎉🎉🎉🎉🎉🎉\n" }.join("")

          return Logger::log_info("You won!")
        end

        word_to_guess = Dictionary.search(
          included_positional_tokens: included_positional_tokens,
          excluded_positional_tokens: excluded_positional_tokens,
          included_tokens: included_tokens,
          excluded_tokens: excluded_tokens,
        )

        if ENV["DEBUG"]
          Logger.log_debug({
            included_positional_tokens: included_positional_tokens,
            excluded_positional_tokens: excluded_positional_tokens,
            included_tokens: included_tokens,
            excluded_tokens: excluded_tokens,
          })
        end

        if word_to_guess.nil?
          Logger.log_error("We couldn't find the word!")
          return
        end
      end

    rescue Game::OutOfAttemptsError
      Logger.log_error("We ran out of attempts")
      return
    end
  end
end