class GamesController < ApplicationController

  before_action :find_game, only: [ :show, :update ]

  def index
  end

  def create
    @game = Game.new(started_at: Time.now)
    @game.new_game_set!
    
    if @game.save
      # Show game to allow user to start playing
      redirect_to game_path(@game, params: { r: 0 })
    else
      # TODO: add an error message
      render(action: :index) 
    end
  end
  
  def show
    if @game.responses.length == 30
      # Stop playing and show results
    end  
  end
  
  def update
    # Stop timer if it's the final response
    if params[:r].to_i == 29
      @game.finished_at = Time.now
    end
    
    # Record response to current round
    @game.responses << params[:game][:response]
    
    if @game.save
      # Show next round
      redirect_to game_path(@game, params: { r: params[:r].to_i+1 })
    else
      # TODO: add an error message
      render(action: :index) 
    end
  end
  
  protected
    def find_game
      @game = Game.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to games_path
    end
    
  private
    def game_params
      params.require(:game).permit(:response)
    end
    
end
