#####################################################
# Controller::TransactionController                 #
# Desc: Shows transactions made by a user           #
# Comments:                                         #
#####################################################
class TransactionController < ApplicationController

  #Function shows user transactions
  def show
    @transactions = Transaction.where(:user_id => current_user.id).order('created_at DESC')
    render :partial => 'transaction'
  end
end
