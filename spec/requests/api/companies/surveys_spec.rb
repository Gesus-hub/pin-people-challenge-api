# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::Companies::SurveysController' do
  let(:user) { create(:user, :with_company) }
  let(:headers) { auth_headers(user) }
  let(:valid_params) do
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

  describe 'POST /api/companies/:company_id/surveys' do
    context 'when the user is authenticated' do
      it 'creates a survey with questions and options' do
        post "/api/companies/#{user.company.id}/surveys", params: valid_params, headers: headers

        survey = Survey.last
        question = survey.questions.first
        option1, option2 = question.options

        expected_body = {
          data: {
            id: survey.id.to_s,
            title: survey.title,
            created_at: survey.created_at.iso8601(3),
            updated_at: survey.updated_at.iso8601(3),
            company: {
              id: survey.company.id.to_s,
              name: survey.company.name,
              trade_name: survey.company.trade_name,
              email: survey.company.email,
              website_facebook: survey.company.website_facebook,
              business_description: survey.company.business_description,
              status: survey.company.status,
              created_at: survey.company.created_at.iso8601(3),
              updated_at: survey.company.updated_at.iso8601(3),
              discarded_at: survey.company.discarded_at,
              metadata: survey.company.metadata
            },
            questions: [
              {
                id: question.id.to_s,
                content: question.content,
                question_type: question.question_type,
                created_at: question.created_at.iso8601(3),
                updated_at: question.updated_at.iso8601(3),
                options: [
                  {
                    id: option1.id.to_s,
                    value: option1.value,
                    created_at: option1.created_at.iso8601(3),
                    updated_at: option1.updated_at.iso8601(3),
                    discarded_at: option1.discarded_at
                  },
                  {
                    id: option2.id.to_s,
                    value: option2.value,
                    created_at: option2.created_at.iso8601(3),
                    updated_at: option2.updated_at.iso8601(3),
                    discarded_at: option2.discarded_at
                  }
                ]
              }
            ]
          }
        }

        expect(response).to have_http_status(:created)
        expect(json(response.body)).to eq(expected_body)
      end

      context 'when the params are invalid' do
        let(:invalid_params) { { survey: { title: '' } } }

        it 'returns status :unprocessable_entity (422) with errors' do
          post "/api/companies/#{user.company.id}/surveys", params: invalid_params, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json(response.body)).to eq(errors: ['Title não pode ficar em branco'])
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns status :unauthorized (401)' do
        post "/api/companies/#{user.company.id}/surveys"

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Usuário não logado ou token inválido'])
      end
    end
  end
end
