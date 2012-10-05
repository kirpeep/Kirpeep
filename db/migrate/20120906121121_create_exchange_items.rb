class CreateExchangeItems < ActiveRecord::Migration
  def change
    create_table :exchange_items do |t|
      t.string :exchange_id
      t.string :user_listing_id
      t.string :targ_user_id

      t.timestamps
    end
  end
end
