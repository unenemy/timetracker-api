class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :token
      t.datetime :expires_at
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :tokens, :token, unique: true
  end
end
