class AddMetadataToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :metadata, :jsonb, default: {}, null: false
    add_index :users, :metadata, using: :gin
  end
end
