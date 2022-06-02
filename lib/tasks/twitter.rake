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
    config.consumer_key = 'IMGvgDHHEV1T20bIAREopD7vP'
    config.consumer_secret = 'luKARxyFnq6vD0nK15ACH7CFuQHEYH6x9qcAxwNXMDXHBixxgh'
    config.access_token = '1531062177678827520-reFf7v4ImSkuJoSzS02fagQlhpTPZN'
    config.access_token_secret = 'u6XoaHuHCjq6SOtWSQMAVIm5xFlRfybznI1gC42av33XZ'
  end
end
