# frozen_string_literal: true

class User
  class ConfirmationRegisterJob < ApplicationJob
    queue_as :mailers

    def perform(user_id)
      @user = User.find_by(id: user_id)
      return if @user.nil?

      send_email
    end

    private

    def send_email
      UserMailer::ConfirmationRegisterMailer.confirm(
        @user.name,
        @user.email,
        @user.confirmation_token
      ).deliver_now
    end
  end
end
