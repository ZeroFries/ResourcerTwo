# attributes: up, user_id, source_id

class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :source

  def value
  	up ? 1 : -1
  end
end
