# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API::Companies::SurveysController', openapi_spec: 'api/swagger.json' do
  path '/api/companies/{company_id}/surveys' do
    post 'Cria uma pesquisa para a empresa' do
      tags 'Surveys'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :company_id, in: :path, type: :integer, description: 'ID da empresa'

      parameter name: :survey, in: :body, schema: {
        type: :object,
        properties: {
          survey: {
            type: :object,
            properties: {
              title: { type: :string },
              questions_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    content: { type: :string },
                    question_type: { type: :string },
                    options_attributes: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          value: { type: :string }
                        },
                        required: ['value']
                      }
                    }
                  },
                  required: %w[content question_type]
                }
              }
            },
            required: ['title']
          }
        },
        required: ['survey']
      }

      response '201', 'Pesquisa criada com sucesso' do
        schema type: :object, properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              title: { type: :string },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              company: {
                type: :object,
                properties: {
                  id: { type: :string },
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
              },
              questions: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :string },
                    content: { type: :string },
                    question_type: { type: :string },
                    created_at: { type: :string, format: 'date-time' },
                    updated_at: { type: :string, format: 'date-time' },
                    options: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          id: { type: :string },
                          value: { type: :string },
                          created_at: { type: :string, format: 'date-time' },
                          updated_at: { type: :string, format: 'date-time' },
                          discarded_at: { type: :string, nullable: true }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }

        let(:user) { create(:user, :with_company) }
        let(:authorization) { auth_headers(user)['Authorization'] }
        let(:company_id) { user.company.id }
        let(:survey) do
          {
            survey: {
              title: 'Customer Feedback',
              questions_attributes: [
                {
                  content: 'How satisfied are you?',
                  question_type: 'scale',
                  options_attributes: [
                    { value: 'Very Satisfied' },
                    { value: 'Satisfied' }
                  ]
                }
              ]
            }
          }
        end

        run_test!
      end

      response '422', 'Erro na criação da pesquisa' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        let(:user) { create(:user, :with_company) }
        let(:authorization) { auth_headers(user)['Authorization'] }
        let(:company_id) { user.company.id }
        let(:survey) { { survey: { title: '' } } }

        run_test!
      end

      response '401', 'Usuário não autenticado' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        let(:company_id) { user.company.id }

        run_test!
      end
    end
  end
end
