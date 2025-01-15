# frozen_string_literal: true

# This migration comes from activestorage_database (originally 20210815130342)
class CreateActivestorageDatabaseFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :activestorage_database_files do |t|
      t.string :key, null: false, index: { unique: true }
      t.binary :data, null: false
      t.datetime :created_at, null: false
    end
  end
end
