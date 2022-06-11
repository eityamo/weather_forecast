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
    # 都道府県をランダムで選ぶ
    prefecture = Prefecture.all.sample
    # 選んだ都道府県出身のFanza女優の中からランダムに選ぶ
    actress = Actress.where(prefecture_id: prefecture.id).sample
    # 天気予報のAPIを叩く
    uri = URI.parse("https://weather.tsukumijima.net/api/forecast/city/#{prefecture.forecast}")
    json = Net::HTTP.get(uri)
    result = JSON.parse(json, { symbolize_names: true })
    prefecture = result[:location][:prefecture]
    telop = result[:forecasts][1][:telop]
    max_celsius = result[:forecasts][1][:temperature][:max][:celsius]
    min_celsius = result[:forecasts][1][:temperature][:min][:celsius]
    status = "#今夜のお天気お姉さん は \##{actress.name} (#{actress.cup})です。\n明日、#{I18n.l(Date.tomorrow)}の#{prefecture}の天気は#{telop}、最高気温は#{max_celsius}℃、最低気温は#{min_celsius}℃です。\nプロフィール → #{actress.digital}\n#天気予報 #明日の天気 #気象庁"
    weather_image = result[:forecasts][1][:image][:url].gsub('svg', 'png')
    map_image = "https://thumb.ac-illust.com/c2/c2383d5af9d9d6dce6a49b2d35dcd53c_t.jpeg"
    actress_image = actress.image
    image_urls = [map_image, weather_image, actress_image]
    images = image_urls.map do |image_url|
      uri = URI.parse(image_url)
      uri.open
    end
    @client.update_with_media(status, images)
    redirect_to :root
  end
end
