require './wordle'

game = Wordle::Game.new("watch")
solver = Wordle::Solver.new(game)

pp solver.solve