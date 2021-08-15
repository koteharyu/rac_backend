class Api::UsersController < ApplicationController

  def index
    users = User.all
    render json: users, each_serializer: UserSerializer, meta: {
      total_pages: users.total_pages,
      total_count: users.total_count,
      current_page: users.current_page
    }
  end

  def show
    user = User.find(params[:id])
    render json: user, serializer: UserSerializer
  end

  def create
    user = User.new(user_params)
    user.save!
    render json: user, serializer: UserSerializer
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
