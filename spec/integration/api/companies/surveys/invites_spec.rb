# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API::Companies::Surveys::Invites', openapi_spec: 'api/swagger.json' do
  path '/api/companies/{company_id}/surveys/{survey_id}/invites' do
    post 'Envia um convite para participar de uma pesquisa' do
      tags 'Invites'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :company_id, in: :path, type: :integer, description: 'ID da empresa'
      parameter name: :survey_id, in: :path, type: :integer, description: 'ID da pesquisa'

      parameter name: :invite, in: :body, schema: {
        type: :object,
        properties: {
          invite: {
            type: :object,
            properties: {
              email: { type: :string },
              survey_id: { type: :integer }
            },
            required: %w[email survey_id]
          }
        },
        required: ['invite']
      }

      response '201', 'Convite enviado com sucesso' do
        schema type: :object, properties: {
          message: { type: :string }
        }

        let(:user) { create(:user, :with_company) }
        let(:Authorization) { auth_headers(user)['Authorization'] } # Corrigido para definir o cabeçalho
        let(:company_id) { user.company.id }
        let(:survey_id) { create(:survey, company: user.company).id }
        let(:invite) { { invite: { email: 'invitee@example.com', survey_id: survey_id } } }

        before do
          header 'Authorization', Authorization
        end

        run_test!
      end

      response '422', 'Erro no envio do convite' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        let(:user) { create(:user, :with_company) }
        let(:Authorization) { auth_headers(user)['Authorization'] }
        let(:company_id) { user.company.id }
        let(:survey_id) { create(:survey, company: user.company).id }
        let(:invite) { { invite: { email: '', survey_id: survey_id } } }

        before do
          header 'Authorization', Authorization
        end

        run_test!
      end

      response '401', 'Usuário não autenticado' do
        schema type: :object, properties: {
          errors: { type: :array, items: { type: :string } }
        }

        let(:company_id) { create(:company).id }
        let(:survey_id) { create(:survey, company: Company.last).id }
        let(:invite) { { invite: { email: 'invitee@example.com', survey_id: survey_id } } }

        # Não define o cabeçalho de Authorization para simular usuário não autenticado

        run_test!
      end
    end
  end
end
