module SessionsHelper 

  def sign_in(user)
	cookies.permanent.signed[:remember_token] = [user.id, user.salt]
	self.current_user = user
  end

  def sign_out
	cookies.delete(:remember_token)
	self.current_user = nil
  end

  def current_user=(user)
	@current_user = user
  end

  def current_user
	@current_user ||= user_from_remember_token
  end

  #returns true if the user passed
  #is the current user
  def is_current_user(user)
   current_user.id == user.id
  end

  def signed_in?
	!current_user.nil?
  end

  def create
  	user = User.authenticate(params[:session][:email], 
  							 params[:session][:password])

  	if user.nil?
  		flash.now[:error] = "Invalid email/password combination."
  		@title = "Sign In"
  		render 'new'
  	else 
  	    sign_in user
  	    flash.now[:error] = "Welcome, #{user.name}"
  	    redirect_to user
  	end
  end

  def destroy
  	sign_out
  	redirect_to root_path
  end	

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end
  
	private

		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
		end

		def remember_token
			cookies.signed[:remember_token] || [nil,nil]
		end  
end
