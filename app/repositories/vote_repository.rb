class VoteRepository < BaseRepository
	def create(attributes)
		attributes = sanitize_attributes attributes
		attributes.merge!(user_id: current_user.id)

		vote = Vote.where(user_id: attributes[:user_id], source_id: attributes[:source_id]).first_or_initialize
		vote.up = attributes[:up]
		success = vote.save

		return vote, success, ''
	end

	protected

	def klass
		Vote
	end
end