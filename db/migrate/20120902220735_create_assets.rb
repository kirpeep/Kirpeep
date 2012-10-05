class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.belongs_to :user_listing
      t.timestamps
    end
  end
end
