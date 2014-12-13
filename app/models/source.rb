# attributes: title, description, price, time_required, location_dependent, user_id, materials, steps

class Source < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :avatar, :styles => { :medium => "260x130>", :thumb => "100x100>" }, :default_url => 'fractal.gif'
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  has_many :votes
  has_many :comments
  has_many :source_categories
  accepts_nested_attributes_for :source_categories, allow_destroy: true
  has_many :categories, through: :source_categories

  def created_at_date
  	return nil if self.created_at.nil?
  	self.created_at.to_date
  end

  def rating
  	self.votes.reduce(0) {|sum, vote| sum + vote.value}
  end

  def category_names
    if self.emotions.class == Category::ActiveRecord_Associations_CollectionProxy
      self.categories.pluck :name
    else
      self.categories.map &:name
    end
  end
end
