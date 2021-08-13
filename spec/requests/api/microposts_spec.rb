require 'rails_helper'

RSpec.describe "Api::Microposts", type: :request do
  describe 'GET /api/microposts' do
    let!(:microposts) { create_list(:micropost, 5)}
    it '投稿の一覧取得に成功すること' do
      get api_microposts_path
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['microposts']).to match_array(microposts.map{|post|
        include(
          'id' => post.id,
          'content' => post.content,
          'user' => include('id' => post.user.id,
                            'name' => post.user.name)
        )
      })
    end
  end

  describe 'POST /api/microposts' do
    let(:user) { create(:user) }
    let(:token) { Jwt::TokenProvider.call(user_id: user.id)}
    let(:headers) { { Authorization: "Bearer #{token}"}}
    let(:micropost_params) { { micropost: { content: 'micropost spec'}}}
    it '投稿の新規作成に成功すること' do
      post api_microposts_path, params: micropost_params, headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['micropost']).to include(
        'id' => be_present,
        'content' => 'micropost spec',
        'user' => include(
          'id' => user.id
        )
      )
    end
  end
end
