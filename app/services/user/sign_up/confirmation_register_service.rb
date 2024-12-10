# frozen_string_literal: true

class User
  module SignUp
    class ConfirmationRegisterService < ApplicationService
      def initialize(token)
        @token = token
        super
      end

      def call
        if some_error_with_token.present?
          response.add_error(some_error_with_token)
        else
          response.add_result(user)
        end
      end

      private

      attr_reader :token

      def some_error_with_token
        return :token_not_found   if token_not_found?
        return :token_expired     if token_expired?
        return :already_confirmed if already_confirmed?

        confirm_user_account!

        nil
      end

      def confirm_user_account!
        user.update(confirmed_at: Time.current)
      end

      def token_not_found?
        user.nil?
      end

      def token_expired?
        user.confirmation_sent_at &&
          (Time.current.utc > user.confirmation_sent_at.utc + 6.hours)
      end

      def already_confirmed?
        user.confirmed_at.present?
      end

      def user
        @user ||= User.find_by(confirmation_token: token)
      end
    end
  end
end
