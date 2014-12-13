json.sources do
	json.array! sort_by_most_recently_popular(@sources) do |source|
		json.partial! 'source', source: source
	end
end