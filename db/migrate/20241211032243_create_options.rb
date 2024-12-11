class CreateOptions < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    create_table :options, id: :uuid do |t|
      t.string :value, null: false
      t.datetime :discarded_at, index: true

      t.references :question, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
