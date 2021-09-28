# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.string :title, null: false
      t.text :content, null: false

      t.timestamps
    end
    add_index :reports, :created_at
  end
end
