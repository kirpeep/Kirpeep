####################################################
# Controller::PagesController=                     #
# Desc:                                            #
# Comments:  No longer in use                      #
####################################################

class OldPagesController < ApplicationController
before_filter :signed_in_user

	def index
	end

	private 

    	def signed_in_user
      		unless signed_in?
        	store_location
        	redirect_to signin_path, notice: "Please sign in."
        	end
      	end

    	def correct_user
      		@user = User.find(params[:id])
      		redirect_to(root_path) unless current_user?(@user)
    	end
end
