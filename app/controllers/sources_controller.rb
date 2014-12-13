class SourcesController < ApplicationController
	include SourcesHelper
	respond_to :html, :json, only: [:create, :update, :show, :destroy, :index]
	respond_to :html, only: [:new, :edit]
	before_filter :create_repo, except: :new

	def new
		@source = Source.new
	end

	def create
		@source, success, error = @repo.create params[:source]
		render_json_show success, error
	end

	def edit
		@source, success, error = @repo.find_by_id params[:id]
	end

	def update
		@source, success, error = @repo.update params[:source]
		render_json_show success, error
	end

	def show
		@source, success, error = @repo.find_by_id params[:id]
		render_json_show success, error, 404
	end

	def destroy
		@repo.delete params[:id]
		render json: { message: "Successfully deleted source with id #{params[:id]}" }
	end

	def index
		@sources = @repo.search params[:filters]
		if params[:filters]
			@categories = Category.where(id: params[:filters]['categories']) unless params[:filters]['categories'].blank?
		end
	end

	protected

	def create_repo
		@repo = SourceRepository.new current_user, belongs_to_user: true
	end

	def render_json_show(success, error, error_status=500)
		if success
			render :show
		else
			render json: { message: error }, status: error_status
		end
	end
end
