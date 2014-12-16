class CompletedSourcesController < ApplicationController
	respond_to :json
	before_filter :create_repo, except: :new

	def new
		@completed_source = CompletedSource.new
	end

	def create
		@completed_source, success, error = @repo.create params[:completed_source]
		render_json_show success, error
	end

	def edit
		@completed_source, success, error = @repo.find_by_id params[:id]
	end

	def update
		@completed_source, success, error = @repo.update params[:completed_source]
		render_json_show success, error
	end

	def show
		@completed_source, success, error = @repo.find_by_id params[:id]
		render_json_show success, error, 404
	end

	def destroy
		@repo.delete params[:id]
		render json: { message: "Successfully deleted completed_source with id #{params[:id]}" }
	end

	def index
		@completed_sources, success, error = @repo.find
	end

	protected

	def create_repo
		@repo = BaseRepository.new current_user, belongs_to_user: true, unique: true
		@repo.klass = CompletedSource
		@repo
	end

	def render_json_show(success, error, error_status=500)
		if success
			render :show
		else
			render json: { message: error }, status: error_status
		end
	end
end

