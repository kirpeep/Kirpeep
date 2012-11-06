class CreateExchangeItemKirpoints < ActiveRecord::Migration
  def change
  	add_column :exchange_items, :init_user_id, :integer
  	add_column :exchange_items, :kirpoints_amounts, :integer
  end
end
