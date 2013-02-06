class SearchController < ApplicationController

  def search
    flash[:error] = nil
    @userlistings = UserListing.GetAllByQuery(params[:search])
    if @userlistings.empty?
      flash[:error] = 'No results found. Instead browse our recent listings.'
      @userlistings = UserListing.GetAllByQuery(nil)
    end

  	render "show"
  end
end
