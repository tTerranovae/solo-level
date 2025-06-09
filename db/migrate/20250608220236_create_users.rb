class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.integer :level
      t.integer :xp
      t.string :badges
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
