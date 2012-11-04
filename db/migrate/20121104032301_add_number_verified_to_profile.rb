class AddNumberVerifiedToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :number_verified, :boolean
  end
end
