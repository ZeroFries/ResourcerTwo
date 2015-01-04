class CommentsController < ApplicationController
	respond_to :json
	before_filter :create_repo, except: :new

	def new
		@comment = Comment.new
	end

	def create
		@comment, success, error = @repo.create params[:comment]
		render_json_show success, error
	end

	def edit
		@comment, success, error = @repo.find_by_id params[:id]
	end

	def update
		@comment, success, error = @repo.update params[:comment]
		render_json_show success, error
	end

	def show
		@comment, success, error = @repo.find_by_id params[:id]
		render_json_show success, error, 404
	end

	def destroy
		@repo.delete params[:id]
		render json: { message: "Successfully deleted comment with id #{params[:id]}" }
	end

	def index
		@comments, success, error = @repo.find
	end

	protected

	def create_repo
		@repo = BaseRepository.new current_user, belongs_to_user: true
		@repo.klass = Comment
	end

	def render_json_show(success, error, error_status=500)
		if success
			render :show
		else
			render json: { message: error }, status: error_status
		end
	end
end

