class TweetsController < ApplicationController
  def new
    @tweet = Tweet.new
  end

  def create
    Tweet.create(create_params)
    redirect_to :root
  end

  private

  def create_params
    params.require(:tweet).permit(:text, :image)
  end
end
