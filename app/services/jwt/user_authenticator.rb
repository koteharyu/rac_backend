module Jwt::UserAuthenticator
  extend self

  def call(request_headers)
    @request_headers = request_headers
    begin
      payload, _ = Jwt::TokenDecryptor.call(token)
      return User.find(payload['user_id'])
    rescue
      return nil
    end
  end

  def token
    @request_headers['Authorization'].split(' ').last
  end
end
