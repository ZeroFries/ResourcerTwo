class VotesController < ApplicationController
	respond_to :json
	before_filter :create_repo, except: :new

	def new
		@vote = Vote.new
	end

	def create
		@vote, success, error = @repo.create params[:vote]
		render_json_show success, error
	end

	def edit
		@vote, success, error = @repo.find_by_id params[:id]
	end

	def update
		@vote, success, error = @repo.update params[:vote]
		render_json_show success, error
	end

	def show
		@vote, success, error = @repo.find_by_id params[:id]
		render_json_show success, error, 404
	end

	def destroy
		@repo.delete params[:id]
		render json: { message: "Successfully deleted vote with id #{params[:id]}" }
	end

	def index
		@votes, success, error = @repo.find
	end

	protected

	def create_repo
		@repo = VoteRepository.new current_user, belongs_to_user: true
	end

	def render_json_show(success, error, error_status=500)
		if success
			render :show
		else
			render json: { message: error }, status: error_status
		end
	end
end

