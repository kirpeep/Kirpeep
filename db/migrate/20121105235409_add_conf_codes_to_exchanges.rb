class AddConfCodesToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :initConfCode, :string
    add_column :exchanges, :targConfCode, :string
  end
end
