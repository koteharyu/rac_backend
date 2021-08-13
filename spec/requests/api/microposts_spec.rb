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
end
