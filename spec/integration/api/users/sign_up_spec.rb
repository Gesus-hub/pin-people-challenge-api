# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::Users::RegistrationsController', openapi_spec: 'api/swagger.json' do
  path '/api/users/confirm' do
    post 'Confirma o registro do usuário' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :confirmation, in: :body, schema: {
        type: :object,
        properties: {
          token: { type: :string }
        },
        required: ['token']
      }

      response '200', 'Usuário confirmado com sucesso' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              role: { type: :string },
              email: { type: :string },
              metadata: { type: :object },
              company: { type: :null }
            }
          }
        }

        let(:user) do
          create(:user, confirmation_token: 'token_confirm', confirmation_sent_at: Time.current, confirmed_at: nil)
        end
        let(:confirmation) { { token: user.confirmation_token } }

        run_test!
      end

      response '422', 'Token inválido ou expirado' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        let(:confirmation) { { token: 'invalid_token' } }

        run_test!
      end
    end
  end

  path '/api/users/sign_up' do
    post 'Registra um novo usuário e opcionalmente uma empresa' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :sign_up, in: :body, schema: {
        type: :object,
        properties: {
          sign_up: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              password: { type: :string },
              company: {
                type: :object,
                properties: {
                  name: { type: :string },
                  trade_name: { type: :string },
                  email: { type: :string },
                  website_facebook: { type: :string },
                  business_description: { type: :string }
                }
              }
            },
            required: %w[name email password]
          }
        }
      }

      response '201', 'Usuário criado com sucesso' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              role: { type: :string },
              email: { type: :string },
              metadata: { type: :object },
              company: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  trade_name: { type: :string },
                  email: { type: :string },
                  website_facebook: { type: :string },
                  business_description: { type: :string },
                  status: { type: :string },
                  metadata: { type: :object },
                  discarded_at: { type: :string, nullable: true },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        }

        let(:sign_up) do
          {
            sign_up: {
              name: 'Vinicius Guimaraes',
              email: 'vinicius@pinpeople.com.br',
              password: '123456',
              company: {
                name: 'Glambel',
                trade_name: 'Glambel',
                email: 'glambel@glambel.com.br',
                website_facebook: 'https://glambel.com.br',
                business_description: 'Empresa de beleza'
              }
            }
          }
        end

        run_test!
      end

      response '201', 'Usuário criado com sucesso sem empresa' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              role: { type: :string },
              email: { type: :string },
              metadata: { type: :object },
              company: { type: :null }
            }
          }
        }

        let(:sign_up) do
          {
            sign_up: {
              name: 'Vinicius Guimaraes',
              email: 'vinicius@pinpeople.com.br',
              password: '123456'
            }
          }
        end

        run_test!
      end
    end
  end
end
