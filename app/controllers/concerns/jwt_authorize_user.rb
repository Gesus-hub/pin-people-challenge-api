# frozen_string_literal: true

module JwtAuthorizeUser
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!

    private

    def authenticate_user!
      return if authenticated_user?

      render_unauthorized
    end

    def authenticated_user?
      @authenticated_user ||= find_authenticated_user
    end

    def find_authenticated_user
      user_id = decoded_auth_token&.dig(:sub)
      User.find_by(id: user_id) if user_id
    end

    def decoded_auth_token
      @decoded_auth_token ||= decode_token
    end

    def decode_token
      token = request.headers['Authorization']&.split&.last
      Pinpeople::JsonWebToken.decode(token) if token.present?
    end

    def render_unauthorized
      render json: { errors: ['Usuário não logado ou token inválido'] }, status: :unauthorized
    end
  end
end
