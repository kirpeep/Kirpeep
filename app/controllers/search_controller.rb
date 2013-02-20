class SearchController < ApplicationController

  def search
    flash[:error] = nil
    if params[:category] && params[:category] != ""
    @userlistings = UserListing.SearchByQueryAndCategory(params[:search], params[:category])
    else 
    @userlistings = UserListing.SearchByQuery(params[:search])
    end 

    if @userlistings.count == 0
      flash[:error] = 'No results found. Instead browse our recent listings.'
      @userlistings = UserListing.SearchByQuery(nil)
    end

  	render "show"
  end
end
