# attributes: text, user_id, source_id

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :source

  validates :user_id, :source_id, :text, presence: true
end
