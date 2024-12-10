# frozen_string_literal: true

module Pinpeople
  module JsonWebToken
    SECRET_BASE_KEY = ENV.fetch('SECRET_BASE_KEY', 'secret')

    def self.encode(payload, exp = 12.hours.from_now)
      payload[:exp] = exp.to_i

      JWT.encode(payload, SECRET_BASE_KEY)
    end

    def self.decode(token)
      body = JWT.decode(token, SECRET_BASE_KEY).first

      body.symbolize_keys
    rescue StandardError
      nil
    end
  end
end
