class TweetsController < ApplicationController
  before_action :twitter_client, except: :new

  def twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'IMGvgDHHEV1T20bIAREopD7vP'
      config.consumer_secret = 'luKARxyFnq6vD0nK15ACH7CFuQHEYH6x9qcAxwNXMDXHBixxgh'
      config.access_token = '1531062177678827520-reFf7v4ImSkuJoSzS02fagQlhpTPZN'
      config.access_token_secret = 'u6XoaHuHCjq6SOtWSQMAVIm5xFlRfybznI1gC42av33XZ'
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
