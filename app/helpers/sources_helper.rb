module SourcesHelper
	ONE_VOTE = 3600 # seconds == 1 hour

	def sort_by_most_recently_popular(sources)
		sorted = sources.sort_by do |source|
			(ONE_VOTE * source.rating) + source.created_at.to_i
		end.reverse
	end

	def kind_to_icon(kind)
		{
			'Article' => 'file text outline',
			'Book' => 'book', 
			'Video' => 'film',
			'Course' => 'student'
		}[Source::KINDS[kind.to_i]]
	end

	def price_to_description(price)
		['Free', 'Cheap', 'Affordable', 'Expensive'][price.to_i]
	end

	def price_to_dollar_sign(price)
		['_', '$', '$$', '$$$'][price.to_i]
	end

	def vote_button_html(source)
		atr = {
			completed_class: compute_completed_class(source),
			completed_title: compute_completed_title(source),
			up_vote_class: compute_vote_class(source),
			up_vote_title: compute_vote_title(source),
			down_vote_class: compute_vote_class(source, false),
			down_vote_title: compute_vote_title(source, false)
		}

		content_tag(:div, 'Completed', id: 'complete', class: "ui toggle button #{atr[:completed_class]}", title: atr[:completed_title]) +
		content_tag(:div, content_tag(:i, '', class: "thumbs up icon"), id: 'up', class: "ui toggle button #{atr[:up_vote_class]}", title: atr[:up_vote_title]) +
		content_tag(:div, content_tag(:i, '', class: "thumbs down icon"), id: 'down', class: "ui toggle button #{atr[:down_vote_class]}", title: atr[:down_vote_title])
	end

	def get_completed_source(source)
		@completed_source ||= CompletedSource.where(user_id: current_user.id, source_id: source.id).first
	end

	def current_user_completed_source?(source)
		get_completed_source(source).present?
	end

	def current_user_vote(source)
		@vote ||= Vote.where(user_id: current_user.id, source_id: source.id).first
	end

	def current_user_up_vote?(source)
		current_user_vote(source).present? ? current_user_vote(source).up : false
	end

	def current_user_down_vote?(source)
		current_user_vote(source).present? ? !current_user_vote(source).up : false
	end

	protected

	def compute_completed_class(source)
		current_user_completed_source?(@source) ? 'active' : ''
	end

	def compute_completed_title(source)
		"I have #{current_user_completed_source?(@source) ? 'not' : ''} completed this source"
	end

	def compute_vote_class(source, up=true)
		if !current_user_completed_source?(@source)
			return 'disabled'
		elsif (up && current_user_up_vote?(source)) || (!up && current_user_down_vote?(source))
			return 'active'
		end
	end

	def compute_vote_title(source, up=true)
		if !current_user_completed_source?(@source)
			return 'Please complete the resource before voting'
		else
			return "Would #{up ? '' : 'not'} recommend"
		end
	end
end
