require 'swagger_helper'

RSpec.describe 'Api::V1::Comments', type: :request do
  path '/api/v1/posts/{post_id}/comments' do
    get 'Lists all comments' do
      tags 'Comments'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :post_id, in: :path, type: :string, description: 'post id'
      parameter name: :page, in: :query, type: :string, description: 'page number'
      parameter name: :per_page, in: :query, type: :string, description: 'number of comments per page'
      response '200', 'comments fetched' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        run_test!
      end
    end
  end
end

RSpec.describe 'Api::V1::Comments', type: :request do
  path '/api/v1/posts/{post_id}/comments' do
    post 'Creates a comment' do
      tags 'Comments'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :post_id, in: :path, type: :string, description: 'post id'
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string, nullable: false, example: 'body' },
        }
      }

      response '201', 'comment created' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        run_test!
      end
    end
  end
end

RSpec.describe 'Api::V1::Comments', type: :request do
  path '/api/v1/posts/{post_id}/comments/{id}' do
    patch 'Updates a comment' do
      tags 'Comments'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :post_id, in: :path, type: :string, description: 'post id'
      parameter name: :id, in: :path, type: :string, description: 'Comment ID'
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string, nullable: false, example: 'body' },
        }
      }

      response '200', 'comment updated' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        run_test!
      end
    end
  end
end

RSpec.describe 'Api::V1::Comments', type: :request do
  path '/api/v1/posts/{post_id}/comments/{id}' do
    delete 'Deletes a comment' do
      tags 'Comments'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :post_id, in: :path, type: :string, description: 'post id'
      parameter name: :id, in: :path, type: :string, description: 'Comment ID'
      response '200', 'comment deleted' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        run_test!
      end
    end
  end
end


