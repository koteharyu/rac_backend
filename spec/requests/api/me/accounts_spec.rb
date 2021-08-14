require 'rails_helper'

RSpec.describe "Api::Me::Accounts", type: :request do
  describe "PATCH /api/me" do
    let(:user) { create(:user) }
    let(:token) { Jwt::TokenProvider.call(user_id: user.id)}
    let(:headers) {{ Authorization: "Bearer #{token}"}}
    let(:user_params) { { user: { name: "spec_name", "introduction": "spec_introduction"}}}
    context 'ログイン済みである場合' do
      it 'ユーザー情報の更新に成功すること' do
        patch api_me_account_path, params: user_params, headers: headers
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['user']).to include(
          'id' => be_present,
          'name' => 'spec_name',
          'email' => user.email,
          'introduction' => 'spec_introduction'
        )
      end
    end
  end
end
