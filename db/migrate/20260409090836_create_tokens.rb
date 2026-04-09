class CreateTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :tokens do |t|
      t.string :code, null: false
      t.references :customer, null: true, foreign_key: true
      t.string :label
      t.datetime :expires_at
      t.datetime :activated_at
      t.datetime :revoked_at
      t.bigint :created_by_id, null: false

      t.timestamps
    end

    add_index :tokens, :code, unique: true
    add_foreign_key :tokens, :admin_users, column: :created_by_id
  end
end
