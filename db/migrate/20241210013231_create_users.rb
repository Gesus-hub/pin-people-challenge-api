class CreateUsers < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    create_enum :user_role, %w[employee admin human_resources]

    create_table :users, id: :uuid do |t|
      t.string :name,                    null: false
      t.string :email,                   null: false, index: { unique: true, where: "discarded_at IS NULL" }
      t.enum :role,                      default: :human_resources, null: false, enum_type: :user_role, index: true
      t.string :password_digest
      t.jsonb :metadata,                 index: { using: :gin, algorithm: :concurrently }, default: {}
      t.boolean :request_new_password,   default: false
      t.integer :sign_in_count,          default: 0, null: false
      t.datetime :last_sign_in_at
      t.inet :last_sign_in_ip
      t.string :reset_password_token,    index: { unique: true, algorithm: :concurrently }
      t.datetime :reset_password_sent_at
      t.string :confirmation_token,      index: { unique: true }
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.integer :status,                 default: 1
      t.datetime :discarded_at,          index: true

      t.timestamps
    end
  end
end
