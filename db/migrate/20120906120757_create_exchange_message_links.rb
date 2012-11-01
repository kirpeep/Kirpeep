class CreateExchangeMessageLinks < ActiveRecord::Migration
  def change
    create_table :exchange_message_links do |t|
      t.string :exchange_id
      t.string :message_id

      t.timestamps
    end
  end
end
