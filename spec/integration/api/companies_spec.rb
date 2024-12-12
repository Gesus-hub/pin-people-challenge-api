# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::CompaniesController', openapi_spec: 'api/swagger.json' do
  path '/api/companies' do
    get 'Lista todas as empresas' do
      tags 'Companies'
      produces 'application/json'

      response '200', 'Lista de empresas' do
        schema type: :object, properties: {
          data: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                trade_name: { type: :string },
                email: { type: :string },
                website_facebook: { type: :string },
                business_description: { type: :string },
                status: { type: :string },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' },
                discarded_at: { type: :string, nullable: true },
                metadata: { type: :object }
              }
            }
          }
        }

        let(:user) { create(:user) }
        let(:authorization) { auth_headers(user)['Authorization'] }

        run_test!
      end

      response '401', 'Usuário não autenticado' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        run_test!
      end
    end
  end

  path '/api/companies/{id}' do
    get 'Exibe uma empresa específica' do
      tags 'Companies'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ID da empresa'

      response '200', 'Dados da empresa' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              trade_name: { type: :string },
              email: { type: :string },
              website_facebook: { type: :string },
              business_description: { type: :string },
              status: { type: :string },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              discarded_at: { type: :string, nullable: true },
              metadata: { type: :object }
            }
          }
        }

        let(:user) { create(:user) }
        let(:authorization) { auth_headers(user)['Authorization'] }
        let(:id) { create(:company).id }

        run_test!
      end

      response '404', 'Empresa não encontrada' do
        schema type: :object, properties: {
          error: { type: :string }
        }

        let(:user) { create(:user) }
        let(:authorization) { auth_headers(user)['Authorization'] }
        let(:id) { 0 }

        run_test!
      end

      response '401', 'Usuário não autenticado' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        let(:id) { create(:company).id }

        run_test!
      end
    end
  end

  path '/api/companies' do
    post 'Cria uma nova empresa' do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: {
          company: {
            type: :object,
            properties: {
              name: { type: :string },
              trade_name: { type: :string },
              email: { type: :string },
              website_facebook: { type: :string },
              business_description: { type: :string },
              status: { type: :string }
            },
            required: %w[name email]
          }
        }
      }

      response '201', 'Empresa criada com sucesso' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              trade_name: { type: :string },
              email: { type: :string },
              website_facebook: { type: :string },
              business_description: { type: :string },
              status: { type: :string },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              discarded_at: { type: :string, nullable: true },
              metadata: { type: :object }
            }
          }
        }

        let(:user) { create(:user) }
        let(:authorization) { auth_headers(user)['Authorization'] }
        let(:company) { { company: attributes_for(:company) } }

        run_test!
      end

      response '422', 'Erro na criação da empresa' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        let(:user) { create(:user) }
        let(:authorization) { auth_headers(user)['Authorization'] }
        let(:company) { { company: attributes_for(:company, name: nil) } }

        run_test!
      end

      response '401', 'Usuário não autenticado' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        let(:company) { { company: attributes_for(:company) } }

        run_test!
      end
    end
  end
end
