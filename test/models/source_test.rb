require 'test_helper'

class SourceTest < ActiveSupport::TestCase
  def setup
  	@source = Source.create!
  end

  test '#created_at_date' do
  	assert_equal Time.now.to_date, @source.created_at_date
  end

  test '#rating' do
  	assert_equal 0, @source.rating

  	3.times {|i| @source.votes.create(up: true, user_id: i)}
  	assert_equal 3, @source.rating

  	@source.votes.create(up: false, user_id: 99)
  	assert_equal 2, @source.rating
  end
end
