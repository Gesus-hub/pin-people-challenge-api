# frozen_string_literal: true

module Surveys
  class CreatorService
    attr_reader :survey, :errors

    def initialize(current_user:, survey_params:)
      @current_user = current_user
      @survey_params = survey_params
      @errors = []
    end

    def call
      ActiveRecord::Base.transaction do
        build_survey
        save_survey
      end

      success?
    rescue StandardError => e
      handle_error(e)
      false
    end

    private

    def build_survey
      @survey = Survey.new(@survey_params)
      @survey.company = @current_user.company
    end

    def save_survey
      return if @survey.save

      @errors.concat(@survey.errors.full_messages)
      raise ActiveRecord::Rollback
    end

    def success?
      @errors.empty?
    end

    def handle_error(exception)
      @errors << exception.message
    end
  end
end
