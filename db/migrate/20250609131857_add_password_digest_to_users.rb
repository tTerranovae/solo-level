class AddPasswordDigestToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :password_digest, :string
    # Set a default password for existing users
    User.find_each do |user|
      user.password = 'changeme123'
      user.save(validate: false)
    end
    # Now make the column non-nullable
    change_column_null :users, :password_digest, false
  end

  def down
    remove_column :users, :password_digest
  end
end
