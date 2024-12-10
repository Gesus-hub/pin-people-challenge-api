# frozen_string_literal: true

# Base class for service creation.
# By inheriting this class you do get the possibility of the return a standard response object and keeping
# its standard execution through of `call` class method.
#
#   class PowerService < ApplicationService
#     def initialize(*args, &block)
#       super
#       # anything here ...
#     end
#
#     def call
#       # process anything ...
#
#       response.add_error(:my_error) if anything_is_unsuccessfully
#
#       response.result = 'my result'
#       response
#     end
#   end
#
#   s = PowerService.call(my_params)
#   s.ok?                   # true when there no errors
#   s.errors.full_messages  # same behavior of the ActiveModel::Errors
#   s.result
#
# You can add the translate file for your services
# The file has the following format:
#
#   pt-BR:
#     services:
#       errors:
#         power_service:
#           my_error: Meu super error
#
class ApplicationService
  extend ActiveModel::Naming

  # builds the Service instance and send the call message
  # @return [ResponseService] an object of return of the Service
  def self.call(...)
    new(...).call
  end

  def initialize(*)
    @response = ResponseService.new(self)
  end

  # Necessary dependency for ActiveModel::Errors
  def self.human_attribute_name(_attr, _options = {}); end

  def read_attribute_for_validation(attr); end

  protected

  attr_reader :response

  class ResponseService
    attr_accessor :result
    attr_reader :errors

    def initialize(base)
      @base = base
      @errors = Errors.new(@base)
    end

    # Verifies if has errors
    # @return [Boolean] true when there are no errors
    def ok?
      errors.empty?
    end

    # Allows adding errors in response
    # @return [Object] itself instance
    def add_error(error_key)
      @errors.add(@base.class.name.underscore, error_key)
      self
    end

    # Allows adding a result in response
    # @return [Object] itself instance
    def add_result(content)
      @result = content
      self
    end

    # Custom error class to change the behavior of the standard translation
    class Errors < ActiveModel::Errors
      class Error < ActiveModel::Error
        def self.generate_message(attribute, type = :invalid, _base = nil, _options)
          key = "services.errors.#{attribute}.#{type}"

          I18n.t(key)
        end

        def self.full_message(attribute, message, _base)
          super.strip!
        end
      end

      def add(attribute, type = :invalid)
        attribute, type = normalize_arguments(attribute, type)
        error = Error.new(@base, attribute, type)

        @errors.append(error)

        error
      end
    end
  end
end
