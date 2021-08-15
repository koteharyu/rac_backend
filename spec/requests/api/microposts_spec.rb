require 'rails_helper'

RSpec.describe "Api::Microposts", type: :request do
  describe 'GET /api/microposts' do
    context 'ページングなし' do
      let!(:microposts) { create_list(:micropost, 5) }
      it 'マイクロポストの一覧が取得できること' do
        get api_microposts_path
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['microposts']).to match_array(microposts.map { |micropost|
          include(
            'id' => micropost.id,
            'content' => micropost.content,
            'created_at' => be_present,
            'updated_at' => be_present,
            'user' => include(
              'id' => micropost.user.id
            )
          )})
      end
    end

    context 'ページングあり' do
      let!(:microposts) { create_list(:micropost, 21) }
      it 'マイクロポストの一覧が取得できること(pagination)' do
        get api_microposts_path
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['meta']).to include(
          'total_pages' => 3,
          'total_count' => 21,
          'current_page' => 1
        )
      end
    end
  end

  describe 'GET /api/microposts/:id' do
    let(:micropost) { create(:micropost)}
    it '投稿の詳細の取得に成功すること' do
      get api_micropost_path(micropost)
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['micropost']).to include(
        'id' => micropost.id,
        'content' => micropost.content,
        'created_at' => be_present,
        'updated_at' => be_present,
        'user' => include(
          'id' => micropost.user.id
        )
      )
    end
  end

  describe 'POST /api/microposts' do
    let(:user) { create(:user) }
    let(:token) { Jwt::TokenProvider.call(user_id: user.id)}
    let(:headers) { { Authorization: "Bearer #{token}"}}
    let(:micropost_params) { { micropost: { content: 'micropost spec'}}}
    context '認証済みである場合' do
      it '投稿の新規作成に成功すること' do
        post api_microposts_path, params: micropost_params, headers: headers
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['micropost']).to include(
          'id' => be_present,
          'content' => 'micropost spec',
          'created_at' => be_present,
          'updated_at' => be_present,
          'user' => include(
            'id' => user.id
          )
        )
      end
    end

    context '未認証の場合' do
      it '投稿の作成に失敗すること' do
        post api_microposts_path, params: micropost_params
        expect(response).to have_http_status(401)
        json = JSON.parse(response.body)
        expect(json['error']).to include(
          "messages" => ["ログインしてください"]
        )
      end
    end

    context '不正なパラメータの場合' do
      let(:invalid_params) { { micropost: { content: nil}}}
      it '422 statusが返ること' do
        post api_microposts_path, params: invalid_params, headers: headers
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PATCH /api/microposts/:id' do
    let(:user) { create(:user)}
    let(:token) { Jwt::TokenProvider.call(user_id: user.id)}
    let(:headers) {{ Authorization: "Bearer #{token}"}}
    let(:micropost) { create(:micropost, user: user)}
    let(:micropost_params) { { micropost: { content: 'hoge hoge'}}}
    context '認証済みの場合' do
      it '投稿の更新に成功すること' do
        patch api_micropost_path(micropost), params: micropost_params, headers: headers
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['micropost']).to include(
          'id' => be_present,
          'content' => 'hoge hoge',
          'created_at' => be_present,
          'updated_at' => be_present,
          'user' => include(
            'id' => user.id
          )
         )
      end
    end

    context '未認証である場合' do
      it '投稿の更新に失敗すること' do
        patch api_micropost_path(micropost), params: micropost_params
        expect(response).to have_http_status(401)
        json = JSON.parse(response.body)
        expect(json['error']).to include(
          "messages" => ["ログインしてください"]
        )
      end
    end

    context 'contentが空場合' do
      let(:nil_params) { { micropost: { content: nil}}}
      it '422 statusが返ること' do
        patch api_micropost_path(micropost), params: nil_params, headers: headers
        expect(response).to have_http_status(422)
      end
    end

    context 'contentが140文字以上である場合' do
      let(:more_than_params) { { micropost: { content: "a" * 141 }}}
      it '422 statusが返ること' do
        patch api_micropost_path(micropost), params: more_than_params, headers: headers
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /api/micropost/:id' do
    let(:user) { create(:user)}
    let(:token) { Jwt::TokenProvider.call(user_id: user.id)}
    let(:headers) { { Authorization: "Bearer #{token}"}}
    let(:micropost) { create(:micropost, user: user)}
    context '認証済みである場合' do
      it '投稿の削除に成功すること' do
        delete api_micropost_path(micropost), headers: headers
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['micropost']).to include(
          'id' => be_present,
          'content' => micropost.content,
          'created_at' => be_present,
          'updated_at' => be_present,
          'user' => include(
            'id' => user.id
          )
        )
      end
    end

    context '未認証である場合' do
      it '投稿の削除に失敗すること' do
        delete api_micropost_path(micropost)
        expect(response).to have_http_status(401)
        json = JSON.parse(response.body)
        expect(json['error']).to include(
          "messages" => ["ログインしてください"]
        )
      end
    end
  end

end
