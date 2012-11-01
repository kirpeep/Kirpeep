class AddPaperclipToAssets < ActiveRecord::Migration
  def self.up
  	add_column :assets, :photo_file_name,    :string
  	add_column :assets, :photo_content_type, :string
  	add_column :assets, :photo_file_size,    :integer
  end

  def self.down
  	remove_column :assets, :photo_file_name
  	remove_column :assets, :photo_content_type
  	remove_column :assets, :photo_file_size
  end
end
