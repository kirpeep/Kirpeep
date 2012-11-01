class AddPhoneToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :phone_number, :integer
  end
end
