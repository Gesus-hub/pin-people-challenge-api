# frozen_string_literal: true

class Company
  class Creator < ApplicationService
    def initialize(data = {})
      @data = data.to_h
      super
    end

    def call
      company = build_company

      if company.save
        response.add_result(company)
      else
        company.errors.each { |error| response.add_error(error.full_message) }
      end

      response
    end

    private

    attr_reader :data

    def build_company
      Company.new(data)
    end
  end
end
