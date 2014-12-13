require 'test_helper'

class SourcesHelperTest < ActionView::TestCase
	include SourcesHelper

	def setup
	end

	test '#sort_by_most_recently_popular' do
		suppress_warnings { SourcesHelper::ONE_VOTE = 28800 } # 1 vote == 8 hours
		source1 = Source.create! created_at: Time.now
		source2 = Source.create! created_at: Time.now - 1.days
		source3 = Source.create! created_at: Time.now - 2.days
		# 2 days = -6 votes
		3.times { source1.votes.create up: false }
		3.times { source2.votes.create up: true }
		5.times { source3.votes.create up: true }

		sorted_sources = sort_by_most_recently_popular [source1, source2, source3]

		assert_equal source2, sorted_sources.first
		assert_equal source3, sorted_sources.second
		assert_equal source1, sorted_sources.last
	end
end
