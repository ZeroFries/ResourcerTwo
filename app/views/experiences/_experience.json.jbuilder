source.attributes.keys.each do |k|
	json.extract! source, k.to_sym
end
json.extract! source, :rating
json.extract! source, :emotion_names
json.extract! source, :category_names