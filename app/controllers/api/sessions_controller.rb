class Api::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])
    if user&.find_by(session_params[:password])
      token = Jwt::TokenProvider.call(user_id: user.id)
      render json: { user: ActiveModelSerializers::SerializableResource.new(user, adapter: :attributes), token: token }, status: :created
    else
      render json: { error: { messages: ['メールアドレスまたはパスワードに誤りがあります。'] } }, status: :unauthorized
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
