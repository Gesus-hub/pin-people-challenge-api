# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtAuthorizeUser do
  # rubocop:disable RSpec/DescribedClass
  controller(ApplicationController) do
    include JwtAuthorizeUser

    def index
      render json: { message: 'OK' }
    end
  end
  # rubocop:enable RSpec/DescribedClass

  describe 'GET #index' do
    context 'with a valid JWT token' do
      it 'returns HTTP status :ok (200)' do
        jwt = Pinpeople::JsonWebToken.encode(sub: create(:user).id)

        request.headers.merge('Authorization' => jwt)

        get :index

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with an expired JWT token' do
      it 'returns HTTP status :unauthorized (401) with an error message' do
        jwt = Pinpeople::JsonWebToken.encode({ sub: create(:user).id }, 1.minute.ago)

        request.headers.merge('Authorization' => jwt)

        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to match_array(errors: ['Usuário não logado ou token inválido'])
      end
    end

    context 'with a JWT token for a non-existent user' do
      it 'returns HTTP status :unauthorized (401) with an error message' do
        jwt = Pinpeople::JsonWebToken.encode(sub: 999)

        request.headers.merge('Authorization' => jwt)

        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to match_array(errors: ['Usuário não logado ou token inválido'])
      end
    end

    context 'without a JWT token' do
      it 'returns HTTP status :unauthorized (401) with an error message' do
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(json(response.body)).to match_array(errors: ['Usuário não logado ou token inválido'])
      end
    end
  end
end
