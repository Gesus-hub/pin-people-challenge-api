# frozen_string_literal: true

module RspecApiSupport
  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def auth_headers(user = nil, headers = {})
    { 'Authorization' => "Bearer #{Pinpeople::JsonWebToken.encode(sub: user&.id)}" }.merge(headers)
  end
end
