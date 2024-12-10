# frozen_string_literal: true

class User
  module SignUp
    class RegisterService < ApplicationService
      def initialize(data = {})
        @user = data

        super
      end

      def call
        result = create_user

        User::SignUp::EmailConfirmationRegisterService.call(result.id) if result

        response.add_result(result)
      end

      private

      attr_reader :user

      def create_user
        new_user = User.new(user_params)

        handle_response_for(new_user)
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
