class SearchController < ApplicationController

	def search

	    if signed_in?
	      @user = current_user
	      @userlistings = UserListing.where("user_id != ? AND is_deleted == ?",@user.id.to_s, "false")#.paginate(:per_page => 5, :page => params[:page])#.order(sort_column + " " + sort_direction)
	      #.paginate(:per_page => 5, :page => params[:page]) #.order(sort_column + " " + sort_direction)
	      @userlistings = @userlistings.search(params[:search])
	    else
	      @userlistings = UserListing.search(params[:search])#.paginate(:per_page => 5, :page => params[:page]) #.order(sort_column + " " + sort_direction)
	    end
    	render "show"
  	end
end
