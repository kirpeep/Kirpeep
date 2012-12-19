#####################################################
# Controller::ReviewsController                     #
# Desc: Creates reviews on exchanges that the users #                                           #
# Comments:  #TODO implement reviews                #
#####################################################
class ReviewsController < ApplicationController

	#shows modal for new review.
	#TODO modal needs to be made and reviews do not work at all
	def new
		@review = Review.new
		@targUserId = params[:id]

		@exchanges = exchangesWithCurrentUser(@targUserId)
	end

	#Funcation creates a new Review
	def create
		@review = Review.new params[:initiate_review]
   
	    if @review.save 
	        flash[:notice] = 'review saved.'
	        redirect_to current_user
	    else
	  	  flash[:error] = @review.errors.full_messages.to_sentence
	      redirect_to current_user
	    end
	end
end
