# frozen_string_literal: true

module UserMailer
  class ConfirmationRegisterMailer < ApplicationMailer
    def confirm(name, email, token)
      @name  = name.split.first
      @email = email
      @token = token

      mail(
        to: "#{name} <#{email}>",
        subject: t('mailer.confirmation.subject')
      )
    end
  end
end
