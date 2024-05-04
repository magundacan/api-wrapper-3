class Rawg::V2::Client
  class Error < RuntimeError; end
  class GameNotFound < Error; end

  BASE_URL = 'https://api.rawg.io/api'.freeze
  API_KEY = Rails.application.credentials.rawg_api_key
  ERROR_CODES = {
    404 => GameNotFound
  }.freeze

  # client.games(dates: '2019-09-01,2019-09-30', platforms: '18,1,7')
  # client.games(**{dates: '2019-09-01,2019-09-30', platforms: '18,1,7'})
  def games(**params)
    request(
      method: :get,
      endpoint: "games",
      params: params
    )
  end

  # client.game(1)
  # client.game(1, dates: '2019-09-01,2019-09-30', platforms: '18,1,7')
  # client.game(1, **{dates: '2019-09-01,2019-09-30', platforms: '18,1,7'})
  def game(id, **params)
    request(
      method: :get,
      endpoint: "games/#{id}",
      params: params
    )
  end

  private

  def request(method:, endpoint:, params: {}, headers: {}, body: {})
    response = connection.public_send(method, "#{endpoint}") do |request|
      request.params = { key: API_KEY, **params }
      request.headers = headers   if headers.present?
      request.body = body.to_json if body.present?
    end

    return JSON.parse(response.body).with_indifferent_access if response.success?
    raise ERROR_CODES[response.status]
  end

  def connection
    @connection ||= Faraday.new(url: BASE_URL)
  end
end
