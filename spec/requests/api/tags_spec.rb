require 'rails_helper'

RSpec.describe "Api::Tags", type: :request do
  describe "GET /api/tags" do
    let!(:tags) { create_list(:tag, 5)}
    it 'タグ一覧の取得に成功すること' do
      get api_tags_path
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['tags']).to match_array(tags.map{|tag| include(
        'id' => tag.id,
        'name' => tag.name
      )})
    end
  end
end
