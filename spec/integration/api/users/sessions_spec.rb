# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::Users::SessionsController', openapi_spec: 'api/swagger.json' do
  path '/api/users/sign_in' do
    post 'Autentica um usuário e retorna um token' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[email password]
          }
        }
      }

      response '200', 'Usuário autenticado com sucesso' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              name: { type: :string },
              role: { type: :string },
              email: { type: :string },
              metadata: { type: :object },
              token: { type: :string }
            }
          }
        }

        let(:user) { create(:user, password: '123456') }
        let(:user_params) { { user: { email: user.email, password: '123456' } } }

        run_test!
      end

      response '401', 'Credenciais inválidas' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        context 'when the email is incorrect' do
          let(:user_params) { { user: { email: 'invalid@example.com', password: '123456' } } }

          run_test!
        end

        context 'when the password is incorrect' do
          let(:user) { create(:user, password: '123456') }
          let(:user_params) { { user: { email: user.email, password: 'wrongpassword' } } }

          run_test!
        end

        context 'when the email is blank' do
          let(:user_params) { { user: { email: '', password: '123456' } } }

          run_test!
        end

        context 'when the password is blank' do
          let(:user) { create(:user) }
          let(:user_params) { { user: { email: user.email, password: '' } } }

          run_test!
        end

        context 'when the email is invalid' do
          let(:user_params) { { user: { email: 'invalidemail', password: '123456' } } }

          run_test!
        end

        context 'when the user is not confirmed' do
          let(:user) { create(:user, password: '123456', confirmed_at: nil) }
          let(:user_params) { { user: { email: user.email, password: '123456' } } }

          run_test!
        end
      end
    end
  end
end
