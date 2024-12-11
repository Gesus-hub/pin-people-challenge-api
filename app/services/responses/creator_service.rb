# frozen_string_literal: true

module Responses
  class CreatorService
    attr_reader :errors

    def initialize(current_user:, survey:, response_params:)
      @current_user = current_user
      @survey = survey
      @response_params = response_params
      @errors = []
    end

    def call
      response = Response.new(@response_params)
      response.survey = @survey
      response.user = @current_user

      if response.save
        true
      else
        @errors.concat(response.errors.full_messages)
        false
      end
    end
  end
end
