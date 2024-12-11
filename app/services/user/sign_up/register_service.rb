# frozen_string_literal: true

class User
  module SignUp
    class RegisterService < ApplicationService
      def initialize(data = {})
        @user = data
        @company = data[:company] if data[:company].present?

        super
      end

      def call
        result = company.present? ? create_user_and_company : create_user

        User::SignUp::EmailConfirmationRegisterService.call(result.id) if result

        response.add_result(result)
      end

      private

      attr_reader :user, :company

      def create_user_and_company
        ActiveRecord::Base.transaction do
          company = create_company
          user = create_user(company: company)

          raise ActiveRecord::Rollback if user.blank? || company.blank?

          user.update!(role: 'admin')
          user
        end
      end

      def create_user(company: nil)
        new_user = User.new(user.merge(company: company).merge(confirmation_data))

        handle_response_for(new_user)
      end

      def create_company
        new_company = Company.new(company)

        handle_response_for(new_company)
      end

      def user_params
        user.merge(confirmation_data)
      end

      def confirmation_data
        {
          confirmation_token: generate_confirmation_token,
          confirmation_sent_at: Time.current
        }
      end

      def generate_confirmation_token
        loop do
          uniq = Digest::SHA1.hexdigest("#{user[:email]}#{Time.current}")
          rand_token = "#{uniq}#{SecureRandom.urlsafe_base64(nil, false)}"

          break rand_token unless User.exists?(confirmation_token: rand_token)
        end
      end

      def handle_response_for(record)
        return record.save! && record if record.valid?

        record.errors.each { |err| response.add_error(err.message) }
        false
      end
    end
  end
end
