namespace :twitter do
  desc 'random_twitter'
  task tweet: :environment do
    twitter_client
    status = '今日は曇り'
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
