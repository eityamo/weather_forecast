require 'net/http'
require 'uri'
require 'open-uri'
# Don't allow downloaded files to be created as StringIO. Force a tempfile to be created.
OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
OpenURI::Buffer.const_set 'StringMax', 0

class TweetsController < ApplicationController
  before_action :twitter_client, only: %i[post]

  def twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.credentials.twitter[:consumer_key]
      config.consumer_secret = Rails.application.credentials.twitter[:consumer_secret]
      config.access_token = Rails.application.credentials.twitter[:access_token]
      config.access_token_secret = Rails.application.credentials.twitter[:access_token_secret]
    end
  end

  def new; end

  def post
    prefecture = Prefecture.all.sample
    actress = Actress.where(prefecture_id: prefecture.id).sample
    uri = URI.parse("https://weather.tsukumijima.net/api/forecast/city/#{prefecture.forecast}")
    json = Net::HTTP.get(uri)
    result = JSON.parse(json, { symbolize_names: true })
    prefecture = result[:location][:prefecture]
    telop = result[:forecasts][1][:telop]
    max_celsius = result[:forecasts][1][:temperature][:max][:celsius]
    min_celsius = result[:forecasts][1][:temperature][:min][:celsius]
    status = "お疲れ様です、明日のお天気をお伝えいたします。\n明日の#{prefecture}の天気は#{telop}、最高気温は#{max_celsius}℃、最低気温は#{min_celsius}℃です。\n今夜のお天気お姉さん:#{actress.name}(#{actress.cup})\n#{actress.digital}\n#今夜のお天気お姉さん\n#{actress.image}"
    image_uri = URI.parse(actress.image)
    media = image_uri.open
    @client.update_with_media(status, media)
    redirect_to :root
  end
end
