####################################################
# Controller::SessionsController                   #
# Desc:                                            #
# Comments:                                        #
####################################################

class SessionsController < ApplicationController
  #include SessionsHelper

  #Function show the sign in modal
  def index
  	@title = "Kirpeep | Realize Yourself"
  end

  #Function show the sign in modal
  def signin
  	render :partial  => 'shared/signin'
  end

end
