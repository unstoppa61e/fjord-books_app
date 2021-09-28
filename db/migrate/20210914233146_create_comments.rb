# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, null: false
      t.integer :user_id, null: false
      t.text :body

      t.timestamps
    end
    add_index :comments, :created_at
  end
end
