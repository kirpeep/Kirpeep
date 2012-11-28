class AddDefaultValuesToProfilesAndUsers < ActiveRecord::Migration
  def change
  	change_column :profiles, :interests, :string, :default => 'Click Here to Edit Your Interests'
  	change_column :profiles, :quickPitch, :string, :default => 'Click Here to Edit Your Headline'
  	change_column :profiles, :about, :string, :default => 'Click Here to Edit Your About Me'
  	change_column :profiles, :education, :string, :default => 'Click Here to Edit Your Education'
  	change_column :profiles, :location, :string, :default => 'Click Here to Edit Your Location'
  	change_column :profiles, :languages, :string, :default => 'Click Here to Edit Your Languages'
  	change_column :profiles, :gender, :string, :default => 'Click Here to Edit Your Gender'
  	change_column :profiles, :birthdate, :string, :default => 'Click Here to Edit Your Birthday'
  	change_column :profiles, :zipcode, :string, :default => 'Click Here to Edit Your Zipcode'
  end
end
