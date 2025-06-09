class AddStreakToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :streak, :integer
  end
end
