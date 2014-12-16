# attributes: user_id, source_id

class CompletedSource < ActiveRecord::Base
  belongs_to :user
  belongs_to :source
end
