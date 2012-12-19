#####################################################
# Controller::ExchangeItemsController               #
# Desc: Item created when listing is pulled into an #
# exchange                                          #
# Comments:                                         #
#####################################################

class ExchangeItemsController < ApplicationController

	#Function creates a new ExchangeItem 
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

	#function #TODO [not sure where this is used]
	def new
		@exchange_item = ExchangeItem.new
	end
	
	#function #TODO [not sure where this is used]
	def show

	end

	
end
