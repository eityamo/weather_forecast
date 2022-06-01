class TweetsController < ApplicationController
  before_action :twitter_client, except: :new

  def twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'PgzAlGqrfIQPwsoIrfZYRRYZq'
      config.consumer_secret = 'gQyeNt9In4jIOj50Uh3nSLqIfCU8NcZPGMI0246ayMqvU5RqHm'
      config.access_token = '1531062177678827520-TKJvIzVjeEa9OCs1NJ3RyqW3K5qspX'
      config.access_token_secret = 'ehsEvQIJDds92TxBNbq748T0XEI7vtPnVJbztyHigO2H4'
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
  end

  private

  def create_params
    params.require(:tweet).permit(:text, :image)
  end
end
