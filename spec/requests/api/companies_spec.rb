# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::CompaniesController' do
  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }
  let(:company) { create(:company) }
  let(:valid_params) do
    {
      name: 'My Company',
      trade_name: 'My Trade Name',
      email: 'company@example.com',
      website_facebook: 'http://facebook.com/mycompany',
      business_description: 'My business description',
      status: :active
    }
  end

  describe 'GET /api/companies' do
    context 'when the user is authenticated' do
      before { create(:company) }

      it 'returns HTTP status :ok (200) with list of companies' do
        get '/api/companies', headers: headers

        expect(response).to have_http_status(:ok)
        expect(json(response.body)[:data].size).to eq(1)
      end
    end

    context 'when the user is not authenticated' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        get '/api/companies'

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Usuário não logado ou token inválido'])
      end
    end
  end

  describe 'GET /api/companies/:id' do
    context 'when the user is authenticated' do
      context 'when the company exists' do
        it 'returns HTTP status :ok (200) with company data' do
          get "/api/companies/#{company.id}", headers: headers

          expected_body = {
            data: {
              id: company.id,
              name: company.name,
              email: company.email,
              trade_name: company.trade_name,
              website_facebook: company.website_facebook,
              business_description: company.business_description,
              status: company.status,
              created_at: company.created_at.as_json,
              updated_at: company.updated_at.as_json,
              discarded_at: nil,
              metadata: {}
            }
          }

          expect(response).to have_http_status(:ok)
          expect(json(response.body)).to eq(expected_body)
        end
      end

      context 'when the company does not exist' do
        it 'returns HTTP status :not_found (404) with error message' do
          get '/api/companies/non_existent_id', headers: headers

          expect(response).to have_http_status(:not_found)
          expect(json(response.body)).to eq(error: 'Registro não encontrado.')
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        get "/api/companies/#{company.id}"

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Usuário não logado ou token inválido'])
      end
    end
  end

  describe 'POST /api/companies' do
    context 'when the user is authenticated' do
      context 'when the request is valid' do
        it 'creates a new company and returns HTTP status :created (201)' do
          post '/api/companies', headers: headers, params: { company: valid_params }

          expect(response).to have_http_status(:created)
          expect(json(response.body)[:data][:name]).to eq('My Company')
        end
      end

      context 'when the request is invalid' do
        it 'returns HTTP status :unprocessable_entity (422) with error messages' do
          post '/api/companies', headers: headers, params: { company: valid_params.except(:name) }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json(response.body)).to eq(errors: ['Name não pode ficar em branco'])
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        post '/api/companies', params: { company: valid_params }

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Usuário não logado ou token inválido'])
      end
    end
  end

  describe 'PUT /api/companies/:id' do
    context 'when the user is authenticated' do
      context 'when the company exists' do
        it 'updates the company and returns HTTP status :ok (200)' do
          put "/api/companies/#{company.id}", headers: headers, params: { company: { name: 'Updated Name' } }

          expect(response).to have_http_status(:ok)
          expect(json(response.body)[:data][:name]).to eq('Updated Name')
        end
      end

      context 'when the company does not exist' do
        it 'returns HTTP status :not_found (404)' do
          put '/api/companies/non_existent_id', headers: headers, params: { company: { name: 'Updated Name' } }

          expect(response).to have_http_status(:not_found)
          expect(json(response.body)).to eq(error: 'Registro não encontrado.')
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        put "/api/companies/#{company.id}", params: { company: { name: 'Updated Name' } }

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Usuário não logado ou token inválido'])
      end
    end
  end

  describe 'DELETE /api/companies/:id' do
    context 'when the user is authenticated' do
      context 'when the company exists' do
        it 'soft deletes the company and returns HTTP status :no_content (204)' do
          delete "/api/companies/#{company.id}", headers: headers

          expect(response).to have_http_status(:ok)
          expect(Company.find_by(id: company.id).discarded_at).not_to be_nil
        end
      end

      context 'when the company does not exist' do
        it 'returns HTTP status :not_found (404)' do
          delete '/api/companies/non_existent_id', headers: headers

          expect(response).to have_http_status(:not_found)
          expect(json(response.body)).to eq(error: 'Registro não encontrado.')
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        delete "/api/companies/#{company.id}"

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Usuário não logado ou token inválido'])
      end
    end
  end

  describe 'PUT /api/companies/:id/restore' do
    context 'when the user is authenticated' do
      context 'when the company is discarded' do
        before { company.discard }

        it 'restores the company and returns HTTP status :ok (200)' do
          put "/api/companies/#{company.id}/restore", headers: headers

          expect(response).to have_http_status(:ok)
          expect(Company.find_by(id: company.id).discarded_at).to be_nil
        end
      end

      context 'when the company is not discarded' do
        it 'returns HTTP status :unprocessable_entity (422)' do
          put "/api/companies/#{company.id}/restore", headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns HTTP status :unauthorized (401) with error message' do
        put "/api/companies/#{company.id}/restore"

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to eq(errors: ['Usuário não logado ou token inválido'])
      end
    end
  end
end
