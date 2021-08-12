require 'rails_helper'

RSpec.describe 'Api::Sessions', type: :request do
  describe 'POST /api/session' do
    let!(:user) { create(:user) }
    context '認証情報が正しい場合' do
      let(:session_params) { { session: { email: user.email, password: 'password' } }}
      it 'ログインに成功すること' do
        post api_session_path, params: session_params
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['user']).to include({
          'id' => user.id,
          'name' => user.name,
          'email' => user.email,
          'token' => be_present
        })
      end
    end

    context '認証情報に誤りがある場合' do
      let(:invalid_session_params) { { session: { email: user.email, password: 'invalid password' } }}
      it 'ログインに失敗すること' do
        post api_session_path, params: invalid_session_params
        expect(response).to have_http_status(401)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end
  end
end
