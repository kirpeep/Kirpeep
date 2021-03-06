class Action < ActiveRecord::Base
  attr_accessible :action, :date, :type, :userId

  def self.log(userId, type, action)
     @action = Action.new
     @action.userId = userId
     @action.type = type
     @action.action = action
     @action.date = Time.new
     @action.save
  end
end
