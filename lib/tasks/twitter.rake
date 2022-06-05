require 'net/http'
require 'uri'

namespace :twitter do
  desc 'random_twitter'
  task tweet: :environment do
    uri = URI.parse('https://weather.tsukumijima.net/api/forecast/city/130010')
    json = Net::HTTP.get(uri)
    result = JSON.parse(json, { symbolize_names: true })
    prefecture = result[:location][:prefecture]
    telop = result[:forecasts][1][:telop]
    max_celsius = result[:forecasts][1][:temperature][:max][:celsius]
    min_celsius = result[:forecasts][1][:temperature][:min][:celsius]
    status = "明日の#{prefecture}の天気は#{telop}、最高気温は#{max_celsius}℃、最低気温は#{min_celsius}℃です。"
    twitter_client
    @client.update(status)
  end
end

def twitter_client
  @client = Twitter::REST::Client.new do |config|
    config.consumer_key = Rails.application.credentials.twitter[:consumer_key]
    config.consumer_secret = Rails.application.credentials.twitter[:consumer_secret]
    config.access_token = Rails.application.credentials.twitter[:access_token]
    config.access_token_secret = Rails.application.credentials.twitter[:access_token_secret]
  end
end
