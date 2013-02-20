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

  def create_facebook
    user = User.from_omniauth(env['omniauth.auth'])
    if user.nil?
      flash[:error] = "Invalid email/password combination."
      @title = "Sign In"
      redirect_to root_path
    else 
      sign_in_ user
      flash[:notice] = "Welcome, #{user.name}"
      redirect_to user
    end
  end
end
