class AddPhoneVerifiedToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :phone_verified, :boolean
  end
end
