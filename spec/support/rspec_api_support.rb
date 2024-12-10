# frozen_string_literal: true

module RspecApiSupport
  def json(body)
    JSON.parse(body, symbolize_names: true)
  end
end
