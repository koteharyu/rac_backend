class Api::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    user.save!
    render json: user, status: :created, serializer: UserSerializer
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
