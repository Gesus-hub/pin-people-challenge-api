# frozen_string_literal: true

module Serializable
  extend ActiveSupport::Concern

  included do
    private

    def data_serializer(resource, options = {})
      { data: serialize(resource, options) }
    end

    def serialize(resource, options)
      if options.key?(:serializer)
        options.fetch(:serializer).new(resource).serializable_hash
      else
        "#{model_name_of(resource)}Serializer".constantize.new(resource).serializable_hash
      end
    end

    def model_name_of(resource)
      case resource
      when Array
        resource.first.class.try(:model_name)&.name
      when ActiveRecord::Relation
        resource.model_name.name
      else
        resource.class.try(:model_name)&.name
      end
    end

    def errors_serializer(error_messages, options)
      { json: ErrorSerializer.new(error_messages).serializable_hash, **options }
    end
  end
end
