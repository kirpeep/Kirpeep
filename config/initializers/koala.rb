#Koala::Facebook::OAuth.class_eval do
#  def initialize_with_defualt_settings(*args)
#        raise "application id and/or secret are not specified in config/environment.rb" unless Facebook::APP_ID && Facebook::SECRET
#        initialize_without_default_settings(ENV['FACEBOOK_APP_ID'].to_s, ENV['FACEBOOK_SECRET'].to_s, args.first)
#  end
#
#  alias_method_chain :initialize, :default_settings
#end
