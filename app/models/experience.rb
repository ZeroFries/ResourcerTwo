# attributes: title, description, price, time_spent_in_minutes, location_dependent, user_id

class Experience < ActiveRecord::Base
  belongs_to :user
  
  has_many :experience_emotions
  has_many :emotions, through: :experience_emotions
  has_many :votes
  has_many :comments
  has_many :experience_categories
  has_many :categories, through: :experience_categories

  def created_at_date
  	return nil if self.created_at.nil?
  	self.created_at.to_date
  end

  def rating
  	self.votes.reduce(0) {|sum, vote| sum + vote.value}
  end

  def emotion_names
    if self.emotions.class == Emotion::ActiveRecord_Associations_CollectionProxy
      self.emotions.pluck :name
    else
      self.emotions.map &:name
    end
  end

  def category_names
    if self.emotions.class == Category::ActiveRecord_Associations_CollectionProxy
      self.categories.pluck :name
    else
      self.categories.map &:name
    end
  end
end
