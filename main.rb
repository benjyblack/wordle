require './wordle'

# game = Wordle::Game.new("watch")
solver = Wordle::Solver.new

pp solver.solve