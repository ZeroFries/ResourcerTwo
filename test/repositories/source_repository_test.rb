require 'test_helper'

class SourceRepositoryTest < ActiveSupport::TestCase
  def setup
  	@repo = SourceRepository.new current_user, belongs_to_user: true
  end

  test '#search' do
    assert_equal 0, @repo.search.count
  	source_count = create_sources.count
  	results = @repo.search 
  	assert_equal source_count, results.count
  end

  test '#search for keywords matches struby of words in title and description' do
  	create_sources
  	results = @repo.search keywords: ['title']
  	assert_equal 2, results.size

  	results = @repo.search keywords: ['description', '1']
  	assert_equal 1, results.size

  	results = @repo.search keywords: ["title 1"]
  	assert_equal 1, results.size

  	results = @repo.search keywords: ['abc']
  	assert_equal 1, results.size

  	results = @repo.search keywords: ['ab', 'cde']
  	assert_equal 1, results.size

  	results = @repo.search keywords: ['abc', 'title']
  	assert_equal 0, results.size

  	results = @repo.search keywords: ['nope']
  	assert_equal 0, results.size
  end

  test '#search for category with names' do
  	create_sources
  	results = @repo.search categories: ['ruby']
  	assert_equal 1, results.size

  	results = @repo.search categories: ['ruby']
  	assert_equal 1, results.size

  	results = @repo.search categories: ['ruby', 'javascript']
  	assert_equal 2, results.size

  	results = @repo.search categories: [nil]
  	assert_equal 0, results.size
  end

  test '#search order_by' do
    sources = create_sources
    results = @repo.search({}, 'updated_at')
    assert_equal sources.map(&:id).reverse, results.map(&:id)
  end

  test '#search by arbitrary attributes' do
  	create_sources
  	results = @repo.search price: 0
  	assert_equal 1, results.size

  	results = @repo.search user_id: current_user.id
  	assert_equal 1, results.size

  	results = @repo.search price: 0, user_id: current_user.id
  	assert_equal 1, results.size

  	results = @repo.search price: 0, user_id: 999
  	assert_equal 0, results.size
  end

  test '#search limit_by' do
    sources = create_sources
    results = @repo.search({}, 'updated_at', 2)
    assert_equal 2, results.size
    refute_equal source.size, results.size
  end

  test '#search for location' do
  end

  def create_sources
  	cat_1 = Category.create name: 'cat_1'
  	cat_2 = Category.create name: 'cat_2'
  	sources = []
  	sources << Source.create!(title: 'Title 1', description: 'description 1', user_id: current_user.id, price: 0, updated_at: Time.now)
  	sources << Source.create!(title: 'title 2', description: 'description 2', user_id: 999, price: 1, updated_at: Time.now - 1.days)
  	sources << Source.create!(title: 'abc', description: 'cde', user_id: 999, price: 1, updated_at: Time.now - 2.days)
  	sources.second.categories.create name: 'ruby'
  	sources.last.categories.create name: 'javascript'
  	sources
  end
end