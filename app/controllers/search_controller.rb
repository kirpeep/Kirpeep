#####################################################
# Controller::SearchController                      #
# Desc: Controller used for searching listing/users #
# Comments:                                         #
#####################################################
class SearchController < ApplicationController

  #Function returns an array of user_listings based on search paramm passed
	def search
	    if signed_in?
	      @user = current_user
              if params[:category] && params[:category] != ""
                @userlistings = UserListing.search(params[:search], :conditions => {:is_deleted => '0', :category => params[:category]}, :per_page => 100)
              else
	        @userlistings = UserListing.search(params[:search], :conditions => {:is_deleted => '0'},:per_page => 100)
              end
              Action.log @user.id, 'search', params[:search].to_s()
	    else
              if params[:cagtegory] && params[:category] != ""
                @userlistings = UserListing.search(params[:search], :conditions => {:is_deleted => '0', :category => params[:category]}, :per_page => 100)
              else
	        @userlistings = UserListing.search(params[:search], :conditions => {:is_deleted => '0'}, :per_page => 100)
              end
              Action.log 0, 'search', params[:search].to_s()
	    end

            if @userlistings.empty?
              flash[:error] = 'No results found. Instead browse our recent listings.'
              @userlistings = UserListing.search(nil, :per_page => 100)
            end
    	render "show"
  	end
end
