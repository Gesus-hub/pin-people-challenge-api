# frozen_string_literal: true

module Api
  module Users
    class SessionsController < ::ApplicationController
      def create
        response = User::SignIn::AuthenticatorService.call(sign_in_params[:email], sign_in_params[:password])

        if response.ok?
          render json: data_serializer(response.result)
        else
          render json: { errors: response.errors.full_messages }, status: :unauthorized
        end
      end

      private

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
