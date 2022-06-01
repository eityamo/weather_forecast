class TweetsController < ApplicationController
  before_action :twitter_client, except: :new

  def twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.credentials.twitter[:consumer_key]
      config.consumer_secret = Rails.application.credentials.twitter[:consumer_secret]
      config.access_token = Rails.application.credentials.twitter[:access_token]
      config.access_token_secret = Rails.application.credentials.twitter[:access_token_secret]
    end
  end

  def new
    @tweet = Tweet.new
  end

  def create
    Tweet.create(create_params)
    redirect_to :root
  end

  def post
    status = '今日は晴れ'
    @client.update(status)
    redirect_to :root
  end

  private

  def create_params
    params.require(:tweet).permit(:text, :image)
  end
end
