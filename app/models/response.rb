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

# == Schema Information
#
# Table name: responses
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  value        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  question_id  :uuid             not null
#  survey_id    :uuid             not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_responses_on_discarded_at           (discarded_at)
#  index_responses_on_question_id            (question_id)
#  index_responses_on_survey_id              (survey_id)
#  index_responses_on_survey_id_and_user_id  (survey_id,user_id) UNIQUE
#  index_responses_on_user_id                (user_id)
#
