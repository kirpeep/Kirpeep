class AddDetailsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :gender, :string
    add_column :profiles, :birthdate, :string
    add_column :profiles, :zipcode, :integer
  end
end
