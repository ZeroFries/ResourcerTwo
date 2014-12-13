require 'test_helper'

class SourcesControllerTest < ActionController::TestCase
  def setup
  	current_user
  end

  test '#create json response' do
  	source = Source.new title: 'title', description: 'description', price: 0

  	post :create, source: source.as_json, format: :json

  	json = JSON.parse response.body
  	source_json = json['source']

  	assert_response 200
  	assert_equal source.title, source_json['title']
  	assert_equal source.description, source_json['description']
  	refute_nil source_json['id']
  end

  test '#create error json response' do
  	source = Source.new title: 'title', description: 'description', price: 0

  	post :create, source: source.as_json.merge('bad_attribute' => 1), format: :json

		assert_response 500
  	json = JSON.parse response.body
  	assert_equal 'unknown attribute: bad_attribute', json['message']
  end

  test '#show json response' do
    source = Source.create! title: 'title', description: 'description', price: 0
    source.votes.create up: true
    source.categories.create name: 'ruby'

    get :show, id: source.id, format: :json

    json = JSON.parse response.body
    source_json = json['source']

    assert_response 200
    assert_equal source.title, source_json['title']
    assert_equal source.description, source_json['description']
    assert_equal 1, source_json['rating']
    assert_equal ['ruby'], source_json['category_names']
  end

  test '#show not found json response' do
    get :show, id: 999, format: :json

    json = JSON.parse response.body

    assert_response 404
    assert_equal 'ActiveRecord::RecordNotFound: 999', json['message']
  end

  test '#index' do
    sources = create_sources
    get :index, format: :json

    json = JSON.parse response.body
    sources_json = json['sources']

    assert_response 200
    assert_equal sources.count, sources_json.count
    source_json = sources_json.first
    refute_nil source_json['title']
    refute_nil source_json['description']
    refute_nil source_json['rating']
    refute_nil source_json['category_names']
  end

  test '#index with filters' do
    sources = create_sources
    filters = { 'keywords' => ['title'], 'price' => 0, 'categories' => ['ruby']}
    SourceRepository.any_instance.expects(:search).with(filters).returns sources
    
    get :index, filters: filters, format: :json

    assert_response 200
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
