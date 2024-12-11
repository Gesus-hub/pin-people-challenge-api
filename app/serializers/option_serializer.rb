# frozen_string_literal: true

class OptionSerializer
  def initialize(option)
    @option = option
  end

  def serializable_hash
    hash_for_one_record
  end

  private

  attr_reader :option

  def hash_for_one_record
    {
      id: option.id,
      value: option.value,
      discarded_at: option.discarded_at,
      created_at: option.created_at,
      updated_at: option.updated_at
    }
  end
end
