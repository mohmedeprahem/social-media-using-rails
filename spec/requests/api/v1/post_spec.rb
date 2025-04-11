require 'swagger_helper'

RSpec.describe 'Api::V1::Posts', type: :request do
  path '/api/v1/posts' do
    post 'Creates a post' do
      tags 'Posts'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]

      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, nullable: false, example: 'title' },
          body: { type: :string, nullable: false, example: 'body' },
          tag_ids: { type: :array, items: { type: :integer }, example: [1, 2] }
        },
        required: %w[title body tag_ids]
      }

      response '201', 'post created' do
        let(:post) { { title: 'title', body: 'body', tag_ids: [1, 2] } }
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        run_test!
      end

      response '400', 'invalid request' do
        let(:post) { { title: 'title', body: 'body' } }
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        run_test!
      end
    end
  end

  path '/api/v1/posts' do
    get 'Lists all posts' do
      tags 'Posts'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :page, in: :query, type: :string, description: 'page number'
      parameter name: :per_page, in: :query, type: :string, description: 'number of posts per page'
      response '200', 'posts fetched' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        run_test!
      end
    end
  end

  path '/api/v1/posts/{id}' do
    get 'Shows a post' do
      tags 'Posts'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :id, in: :path, type: :string, description: 'post id'
      response '200', 'post fetched' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        run_test!
      end
    end
  end

  path '/api/v1/posts/{id}' do
    patch 'Update a post' do
      tags 'Posts'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :id, in: :path, type: :string, description: 'Post ID'

      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, nullable: false, example: 'Updated Title' },
          body: { type: :string, nullable: false, example: 'Updated content' },
          tag_ids: {
            type: :array,
            items: { type: :integer },
            example: [1, 2],
            nullable: true
          }
        },
        required: %w[title body]
      }

      response '200', 'post updated' do
        let(:user) { create(:user) }
        let(:post) { create(:post, author: user) }
        let(:id) { post.id }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        let(:post_params) do
          {
            title: 'Updated Title',
            body: 'Updated content',
            tag_ids: [1, 2]
          }
        end
        run_test!
      end

      response '401', 'unauthorized' do
        let(:user) { create(:user) }
        let(:other_user) { create(:user) }
        let(:post) { create(:post, author: other_user) }
        let(:id) { post.id }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        let(:post_params) { { title: 'Try to update', body: 'Should fail' } }
        run_test!
      end

      response '404', 'post not found' do
        let(:user) { create(:user) }
        let(:id) { 'invalid-id' }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        let(:post_params) { { title: 'Try to update', body: 'Should fail' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { create(:user) }
        let(:post) { create(:post, author: user) }
        let(:id) { post.id }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        let(:post_params) { { title: '', body: '' } } # Invalid params
        run_test!
      end
    end
  end

  path '/api/v1/posts/{id}' do
    delete 'Deletes a post' do
      tags 'Posts'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :id, in: :path, type: :string, description: 'Post ID'
      response '200', 'post deleted' do
        let(:user) { create(:user) }
        let(:post) { create(:post, author: user) }
        let(:id) { post.id }
        let(:Authorization) { "Bearer #{JwtService.encode(user_id: user.id)}" }
        run_test!
      end
    end
  end
end
