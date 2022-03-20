require 'yaml'
require './lib/logger'

module Wordle
  seed = ENV["SEED"]&.to_i || Random.new_seed

  if ENV["DEBUG"]
    Logger.log_debug("Using seed #{seed}")
  end

  ALL_WORDS = YAML.load(File.read("./data/words.yml")).shuffle(random: Random.new(seed))

  class Dictionary
    class << self
      # TODO: optimize initial import
      def all
        ALL_WORDS
      end

      def search(
        included_positional_tokens: {},
        excluded_positional_tokens: {},
        included_tokens: [],
        excluded_tokens: []
      )
        all.find do |word|
          positions_match = word.split('').each_with_index.all? do |letter, idx|
            if included_positional_tokens[idx] && included_positional_tokens[idx] != letter
              next false
            end

            if excluded_positional_tokens[idx] && excluded_positional_tokens[idx].include?(letter)
              next false
            end

            true
          end

          next false unless positions_match

          includes_tokens = included_tokens.all? do |letter|
            unless word.include?(letter)
              next false
            end

            true
          end

          next false unless includes_tokens

          excludes_tokens = excluded_tokens.all? do |letter|
            if word.include?(letter)
              next false
            end

            true
          end

          next false unless excludes_tokens

          true
        end
      end
    end
  end
end