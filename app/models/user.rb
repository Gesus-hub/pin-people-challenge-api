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

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  discarded_at           :datetime
#  email                  :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  metadata               :jsonb
#  name                   :string           not null
#  password_digest        :string
#  request_new_password   :boolean          default(FALSE)
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :enum             default("human_resources"), not null
#  sign_in_count          :integer          default(0), not null
#  status                 :integer          default("active")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_discarded_at          (discarded_at)
#  index_users_on_email                 (email) UNIQUE WHERE (discarded_at IS NULL)
#  index_users_on_metadata              (metadata) USING gin
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role                  (role)
#
