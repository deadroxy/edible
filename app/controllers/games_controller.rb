class GamesController < ApplicationController

  def index
  end


  def create
    @game = Game.new
  
    @game.new_game_set!
    
    if @game.save
    else
    end
    
  end
  
  
  
end
