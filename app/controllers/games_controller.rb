class GamesController < ApplicationController
  def index
    client = Rawg::V2::Client.new
    @games = client.games(dates: '2019-09-01,2019-09-30', platforms: '18,1,7')
  end

  def show
    client = Rawg::V2::Client.new
    @game = client.game(params[:id], dates: '2019-09-01,2019-09-30', platforms: '18,1,7')
  rescue Rawg::V2::Client::GameNotFound
    render plain: "OK"
  end
end
