class SearchController < ApplicationController

  def search
    flash[:error] = nil
    if signed_in?
      Action.log current_user.id, 'SearchQuery', params[:search]
    else
      Action.log nil, 'SearchQuery', params[:search]
    end

    if params[:category] && params[:category] != ""
    @userlistings = UserListing.SearchByQueryAndCategory(params[:search], params[:category])
    else 
    @userlistings = UserListing.SearchByQuery(params[:search])
    end 

    if @userlistings.count == 0
      flash[:error] = 'No results found. Instead browse our recent listings.'
      @userlistings = UserListing.SearchByQuery(nil)
    end

    @markers = @userlistings.to_gmaps4rails

  	render "show"
  end
end
