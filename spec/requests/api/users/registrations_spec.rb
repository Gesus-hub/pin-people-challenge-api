# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Users::RegistrationsController' do
  describe 'POST /api/users/sign_up' do
    let(:sign_up_params) do
      {
        name: 'Vinicius Guimaraes',
        role: 'employee',
        email: 'vinicius@pinpeople.com.br',
        password: '123456'
      }
    end

    it 'returns HTTP status :ok (200) with created user data' do
      post '/api/users/sign_up', params: { sign_up: sign_up_params }

      expected_body = {
        data: {
          name: sign_up_params[:name],
          role: sign_up_params[:role],
          email: sign_up_params[:email],
          metadata: {}
        }
      }

      expect(response).to have_http_status(:created)
      expect(json(response.body)).to eq(expected_body)
    end
  end
end
