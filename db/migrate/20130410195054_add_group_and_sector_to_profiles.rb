class AddGroupAndSectorToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :group, :string
    add_column :profiles, :sector, :string
  end
end
