# frozen_string_literal: true

class Response < ApplicationRecord
  include Discard::Model

  belongs_to :survey
  belongs_to :question
  belongs_to :user

  validates :value, presence: true
  validates :user_id, uniqueness: { scope: :survey_id, message: :already_responded }

  def self.active
    where(discarded_at: nil)
  end

  def self.discarded
    where.not(discarded_at: nil)
  end
end
