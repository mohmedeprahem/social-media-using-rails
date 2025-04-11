require 'swagger_helper'

RSpec.describe 'Api::V1::Tags', type: :request do
  path '/api/v1/tags' do
    get 'Lists all tags' do
      tags 'Tags'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'tags fetched' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        run_test!
      end
    end
  end
end
