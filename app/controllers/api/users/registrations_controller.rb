# frozen_string_literal: true

module Api
  module Users
    class RegistrationsController < ::ApplicationController
      def confirm
        response = User::SignUp::ConfirmationRegisterService.call(params[:token])

        if response.ok?
          render json: data_serializer(response.result)
        else
          render json: { errors: response.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def create
        response = User::SignUp::RegisterService.call(sign_up_params)

        if response.ok?
          render json: data_serializer(response.result), status: :created
        else
          render json: { errors: response.errors }, status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.require(:sign_up).permit(:name, :email, :password)
      end
    end
  end
end
