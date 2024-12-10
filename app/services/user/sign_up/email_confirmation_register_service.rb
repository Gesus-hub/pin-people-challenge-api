# frozen_string_literal: true

class User
  module SignUp
    class EmailConfirmationRegisterService < ApplicationService
      attr_reader :user_id

      def initialize(user_id)
        @user_id = user_id
        super
      end

      def call
        User::ConfirmationRegisterJob.perform_now(user_id)
      end
    end
  end
end
