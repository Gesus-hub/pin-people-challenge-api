# frozen_string_literal: true

class Company < ApplicationRecord
  include Discard::Model

  has_many :users, dependent: :destroy
  has_many :surveys, dependent: :destroy

  STATUSES = %i[inactive active].freeze
  enum :status, STATUSES

  validates :name, :trade_name, :email, :website_facebook, :business_description, presence: true
end

# == Schema Information
#
# Table name: companies
#
#  id                   :uuid             not null, primary key
#  business_description :string           not null
#  discarded_at         :datetime
#  email                :string           not null
#  metadata             :jsonb
#  name                 :string           not null
#  status               :integer          default("active")
#  trade_name           :string           not null
#  website_facebook     :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_companies_on_discarded_at  (discarded_at)
#  index_companies_on_metadata      (metadata) USING gin
#
