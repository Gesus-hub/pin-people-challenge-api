# frozen_string_literal: true

class QuestionSerializer
  def initialize(question)
    @question = question
  end

  def serializable_hash
    hash_for_one_record
  end

  private

  attr_reader :question

  def hash_for_one_record
    {
      id: question.id,
      content: question.content,
      question_type: question.question_type,
      created_at: question.created_at,
      updated_at: question.updated_at,
      options: OptionSerializer.new(question.options).serializable_hash
    }
  end
end
