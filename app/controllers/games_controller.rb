class GamesController < ApplicationController

  before_action :find_game, only: [ :show, :update, :add_name ]

  def index
    @leaders = Game.ranked.limit(10)
  end

  def create
    @game = Game.new(started_at: Time.now)
    @game.new_game_set
    
    if @game.save
      # Show game to allow user to start playing
      redirect_to game_path(@game, params: { r: 0 })
    else
      # TODO: add an error message
      render(action: :index)
    end
  end
  
  def show
    # Show result after the final response
    if @game.responses.length == 30
      @game.calculate_score!
      @game.calculate_duration!
      @rank = Game.ranked.pluck(:id).index(@game.id) + 1
      render action: "show_result"
    end
  end
  
  def update
    # Stop timer if it's the final response
    # TODO: This is causing a bug when someone wails on the yes/no buttons
    # The r param is not properly updated and not all responses are being recorded...
    # Need to address this issue
    if params[:r].to_i == 29
      @game.finished_at = Time.now
    end
    
    # TODO: the issue seems to lie with the fact that multiple patch requests can be fired off,
    # we need to prevent that and to store our answers more intelligently
    # Record response to current round
    unless game_params[:response].nil?
      @game.responses << game_params[:response]
    end
    
    if @game.save
      # Show next round
      redirect_to game_path(@game, params: { r: params[:r].to_i+1 })
    else
      # TODO: add an error message
      render(action: :index)
    end
  end
  
  def add_name
    # Add the user's name to the finished game if they enter one
    if !game_params[:name].empty?
      @game.update(game_params)
    end
    redirect_to games_path
  end
  
  protected
    def find_game
      @game = Game.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to games_path
    end
    
  private
    def game_params
      params.require(:game).permit(:response, :name)
    end
    
end
