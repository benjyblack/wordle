require 'colorize'

class Logger
  class << self
    def log_debug(str)
      puts "[DEBUG]: #{str}\n".colorize(color: :light_magenta, mode: :italic)
    end

    def log_info(str)
      puts "* #{str}\n".colorize(color: :green, mode: :bold)
    end

    def log_error(str)
      puts "* #{str}\n".colorize(color: :red, mode: :bold)
    end
  end
end