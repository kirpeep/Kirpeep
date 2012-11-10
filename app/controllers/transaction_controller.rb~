class TransactionController < ApplicationController
  def show
    @transactions = Transaction.where(:user_id => current_user.id).order('created_at DESC')
    render :partial => 'transaction'
  end
end
