# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API::Companies::Surveys::Responses', openapi_spec: 'api/swagger.json' do
  path '/api/companies/{company_id}/surveys/{survey_id}/responses' do
    post 'Cria uma resposta para uma pesquisa' do
      tags 'Responses'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :company_id, in: :path, type: :integer, description: 'ID da empresa'
      parameter name: :survey_id, in: :path, type: :integer, description: 'ID da pesquisa'

      parameter name: :response, in: :body, schema: {
        type: :object,
        properties: {
          response: {
            type: :object,
            properties: {
              user_id: { type: :integer },
              survey_id: { type: :integer },
              question_id: { type: :integer },
              value: { type: :string }
            },
            required: %w[user_id survey_id question_id value]
          }
        },
        required: ['response']
      }

      response '201', 'Resposta salva com sucesso' do
        schema type: :object, properties: {
          message: { type: :string }
        }

        let(:user) { create(:user, :with_company) }
        let(:authorization) { auth_headers(user)['Authorization'] }
        let(:company_id) { user.company.id }
        let(:survey_id) { create(:survey, company: user.company).id }
        let(:question_id) { create(:question, survey_id: survey_id).id }
        let(:response) do
          {
            response: {
              user_id: user.id,
              survey_id: survey_id,
              question_id: question_id,
              value: 'Satisfied'
            }
          }
        end

        run_test!
      end

      response '422', 'Erro ao salvar a resposta' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        let(:user) { create(:user, :with_company) }
        let(:authorization) { auth_headers(user)['Authorization'] }
        let(:company_id) { user.company.id }
        let(:survey_id) { create(:survey, company: user.company).id }
        let(:response) do
          {
            response: {
              user_id: nil,
              survey_id: survey_id,
              question_id: nil,
              value: nil
            }
          }
        end

        run_test!
      end

      response '404', 'Pesquisa não encontrada' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        let(:user) { create(:user, :with_company) }
        let(:authorization) { auth_headers(user)['Authorization'] }
        let(:company_id) { user.company.id }
        let(:survey_id) { 'invalid-id' }
        let(:response) do
          {
            response: {
              user_id: user.id,
              survey_id: survey_id,
              question_id: nil,
              value: 'Satisfied'
            }
          }
        end

        run_test!
      end

      response '401', 'Usuário não autenticado' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        let(:company_id) { user.company.id }
        let(:survey_id) { create(:survey, company: user.company).id }
        let(:question_id) { create(:question, survey_id: survey_id).id }
        let(:response) do
          {
            response: {
              user_id: user.id,
              survey_id: survey_id,
              question_id: question_id,
              value: 'Satisfied'
            }
          }
        end

        run_test!
      end
    end
  end
end
