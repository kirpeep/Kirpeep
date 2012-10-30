####################################################
# Controller::ExchangeItemsController              #
# Desc:                                            #
# Comments:                                        #
####################################################

class ExchangeItemsController < ApplicationController

	def create
		@exchange_item = ExchangeItem.new params[:exchange_item]
		if @exchange_item.save
          flash[:notice] = 'exchange item saved.'
          redirect_to current_user
        
	    else
	    	flash[:error] =error+@exchange_item.errors.full_messages.to_sentence
	        redirect_to current_user
	    end
	end

	def show

	end

	
end
