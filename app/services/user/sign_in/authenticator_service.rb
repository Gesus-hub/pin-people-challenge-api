# frozen_string_literal: true

class User
  module SignIn
    class AuthenticatorService < ApplicationService
      def initialize(email, password)
        @email = email
        @password = password
        super
      end

      def call
        return response.add_error(:user_or_password_invalid) if user.blank? || !authenticated?
        return response.add_error(:account_not_confirmed) if user.account_not_confirmed?

        register_sign_in
        response.add_result(user)
      end

      private

      attr_reader :email, :password

      def user
        @user ||= User.find_by(email:)
      end

      def register_sign_in
        user.update(
          sign_in_count: user.sign_in_count + 1,
          last_sign_in_at: Time.zone.now
        )
      end

      def authenticated?
        user.authenticate(password)
      end
    end
  end
end
