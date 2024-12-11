# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::Companies::Surveys::Responses' do
  let(:user) { create(:user, :with_company) }
  let(:headers) { auth_headers(user) }
  let(:survey) { create(:survey, company: user.company) }
  let(:question) { create(:question, survey: survey) }
  let(:valid_params) do
    {
      response: {
        user_id: user.id,
        survey_id: survey.id,
        question_id: question.id,
        value: 'Satisfied'
      }
    }
  end

  describe 'POST /api/companies/:company_id/surveys/:survey_id/responses' do
    context 'when the user is authenticated' do
      it 'creates a response and returns a success message' do
        post "/api/companies/#{user.company.id}/surveys/#{survey.id}/responses", params: valid_params, headers: headers

        expect(response).to have_http_status(:created)
        expect(json(response.body)).to eq(message: 'Resposta salva com sucesso.')
      end
    end

    context 'when the params are invalid' do
      let(:invalid_params) do
        { response: { user_id: nil, survey_id: survey.id, question_id: question.id, value: nil } }
      end

      it 'returns an error message' do
        post "/api/companies/#{user.company.id}/surveys/#{survey.id}/responses", params: invalid_params,
                                                                                 headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json(response.body)).to include(:errors)
      end
    end

    context 'when the survey is not found' do
      it 'returns a not found error' do
        post "/api/companies/#{user.company.id}/surveys/invalid-survey-id/responses", params: valid_params,
                                                                                      headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json(response.body)).to eq(errors: ['Survey não encontrada.'])
      end
    end

    context 'when the user is not authenticated' do
      it 'returns status :unauthorized (401)' do
        post "/api/companies/#{user.company.id}/surveys/#{survey.id}/responses", params: valid_params

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Usuário não logado ou token inválido'])
      end
    end
  end
end
