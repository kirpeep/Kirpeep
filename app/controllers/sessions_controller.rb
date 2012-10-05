####################################################
# Controller::SessionsController                   #
# Desc:                                            #
# Comments:                                        #
####################################################

class SessionsController < ApplicationController
  #include SessionsHelper

  def index
  	@title = "Kirpeep | Realize Yourself"
  end

  def new
  	render :partial  => 'shared/signin'
  end

  def signin
  	render :partial  => 'shared/signin'
  end

end
