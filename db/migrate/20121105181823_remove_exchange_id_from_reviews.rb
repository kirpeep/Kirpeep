class RemoveExchangeIdFromReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :exchange_id, :integer
    remove_column :reviews, :exchangeID
  end
end
