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
end
