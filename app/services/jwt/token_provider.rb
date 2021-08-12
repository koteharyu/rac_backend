module Jwt::TokenProvider
  extend self

  def call(token)
    issue_token(payload)
  end

  private

  def issue_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
