class Api::MicropostsController < ApplicationController
  before_action :authenticate, only: %i[create update destroy]

  def index
    microposts = Micropost.includes(:user).order(created_at: :desc)
    render json: microposts, each_serializer: MicropostSerializer
  end

  def create
    micropost = current_user.microposts.create!(micropost_params)
    if micropost.save
      render json: micropost, serializer: MicropostSerializer
    else
      render json: micropost.errors, status: 422
    end
  end

  def update
    micropost = current_user.microposts.find(params[:id])
    if micropost.update(micropost_params)
      render json: micropost, serializer: MicropostSerializer
    else
      render json: micropost.errors, status: 422
    end
  end

  def destroy
    micropost = current_user.microposts.find(params[:id])
    micropost.destroy!
    render json: micropost, serializer: MicropostSerializer
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
