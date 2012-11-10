class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :userId
      t.string :type
      t.string :action
      t.datetime :date

      t.timestamps
    end
  end
end
