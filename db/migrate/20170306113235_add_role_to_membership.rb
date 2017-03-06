class AddRoleToMembership < ActiveRecord::Migration[5.0]
  def change
    add_column :memberships, :role, :integer, default: 0
  end
end
