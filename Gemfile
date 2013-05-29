source 'https://rubygems.org'

gem 'rails', '3.2.12'
gem 'rack'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#Database Gem
gem 'mysql2'

#Pagination Gem
gem 'will_paginate', '3.0.3'
gem 'riddle'

#Maps API
gem 'gmaps4rails'

#Search Gems
gem 'delayed_job_active_record'
gem 'sunspot_rails'
gem 'sunspot_solr'

#Admin Page
gem 'activeadmin'
gem "meta_search",    '>= 1.1.0.pre'
##workaround for recent active_admin break
gem 'coffee-script-source', '~> 1.4.0'

#FB GRAPH API INTERFACE
gem 'koala'

#Google Analytics
group :production do
	gem 'rack-google_analytics', :require => "rack/google_analytics"
end	
	
#thin server
gem 'thin'

#Private Pub
gem 'private_pub'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'handlebars_assets'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

#JQuery Gem
gem 'jquery-rails'
#gem 'jquery-ujs'

#In Place Editing Gem
gem 'best_in_place'

#Image Manipulation
gem 'rmagick'

#File uploading Gem
gem 'paperclip'

#Active Merchant gem for CC processing
gem 'activemerchant'

#Twillio
gem 'twilio-ruby'

#Client-side vals
gem 'client_side_validations'

#gem 'css_sprite' #More efficient CSS

group :test, :development, :kyle, :john do
	gem 'rspec-rails'
	gem 'guard-rspec'
	gem 'guard-livereload'
	gem 'launchy'
	#gem 'ruby-debug19'
	gem 'rails-erd'
	gem 'rb-readline'
	#gem 'ruby-debug19'
	gem 'debugger'
end

#Facebook login	
gem 'omniauth-facebook' 


#Run the following the following(each is a line)
#guard init
#rails g #checks if rspec generator is there
#rails g rspec:install
#guard 
#rake routes #see where routes are going
#gem install rb-fsevent
#rails g integration_test [project name]#example 
#tasks’, ‘bookshelf’

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
