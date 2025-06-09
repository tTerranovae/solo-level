class CreateTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :topics do |t|
      t.string :name
      t.text :description
      t.integer :order

      t.timestamps
    end
  end
end
