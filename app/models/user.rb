# frozen_string_literal: true

class User < ApplicationRecord
  include Discard::Model

  has_secure_password

  ROLES = {
    admin: 'admin',
    employee: 'employee',
    human_resources: 'human_resources'
  }.freeze

  enum :role, ROLES

  STATUSES = %i[inactive active].freeze
  enum :status, STATUSES

  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: { conditions: -> { where(discarded_at: nil) } }
end
