class Api::MicropostsController < ApplicationController

  def index
    microposts = Micropost.includes(:user)
    render json: microposts, each_serializer: MicropostSerializer
  end

  def create

  end

  def update

  end

  def destroy

  end
end
