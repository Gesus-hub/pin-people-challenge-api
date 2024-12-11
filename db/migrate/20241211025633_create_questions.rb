class CreateQuestions < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    create_table :questions, id: :uuid do |t|
      t.string :content, null: false
      t.integer :question_type, null: false
      t.datetime :discarded_at,          index: true

      t.references :survey, type: :uuid, foreign_key: true, index: { algorithm: :concurrently }

      t.timestamps
    end
  end
end
