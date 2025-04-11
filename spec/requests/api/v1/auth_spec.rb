require 'swagger_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  path '/api/v1/auth/signup' do
    post 'Creates a user' do
      tags 'Authentication'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :user, in: :formData, schema: {
        type: :object,
        properties: {
          name: { type: :string, nullable: false, example: 'mohamed' },
          email: { type: :string, nullable: false, example: 'mohamed@example.com' },
          password: { type: :string, nullable: false, example: 'password' },
          image: { type: :file, nullable: true }
        },
        required: %w[name email password]
      }

      response '201', 'user created' do
        let(:user) { { name: 'test', email: 'test@example.com', password: 'password' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: 'test' } }
        run_test!
      end
    end
  end

  path '/api/v1/auth/login' do
    post 'Logs in a user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, nullable: false, example: 'mohamed@example.com' },
          password: { type: :string, nullable: false, example: 'password' }
        },
        required: %w[email password]
      }

      response '200', 'user logged in' do
        let(:user) { { email: 'mohamed@example.com', password: 'password' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:user) { { email: 'mohamed@example.com', password: 'wrong_password' } }
        run_test!
      end
    end
  end
end
