class Transaction < ActiveRecord::Base
  attr_accessible :amount, :user_id
  belongs_to :user

  def self.add_transaction(user_id, amount)
    @transaction = Transaction.new

    @transaction.user_id = user_id
    @transaction.amount = amount
    @transaction.save
  end
end
