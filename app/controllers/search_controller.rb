class SearchController < ApplicationController

	def search

	    if signed_in?
	      @user = current_user
	      @userlistings = UserListing.where("user_id != ? AND is_deleted == ?",@user.id.to_s, "false")#.paginate(:per_page => 5, :page => params[:page])#.order(sort_column + " " + sort_direction)
	      #.paginate(:per_page => 5, :page => params[:page]) #.order(sort_column + " " + sort_direction)
	      @userlistings = @userlistings.search(params[:search], :per_page => 100)
              Action.log @user.id, 'search', params[:search].to_s()
	    else
              
	      @userlistings = UserListing.search(params[:search], :per_page => 100)#.paginate(:per_page => 5, :page => params[:page]) #.order(sort_column + " " + sort_direction)
              Action.log 0, 'search', params[:search].to_s()
	    end

            if @userlistings.empty?
              flash[:error] = 'No results found. Instead browse our recent listings.'
              @userlistings = UserListing.search(nil, :per_page => 100)
            end
    	render "show"
  	end
end
