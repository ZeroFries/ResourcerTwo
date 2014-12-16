class @votesService
	@create = (sourceId, isUp) ->
		$.ajax("/votes", method: 'POST', data: {vote : {source_id: sourceId, up: isUp}}).done (data) ->
			$(document).trigger 'votes:created', {vote: data.vote}

	@destroy = (voteId) ->
		$.ajax("/votes/#{voteId}", method: 'DELETE').done (data) ->
			console.log data
			$(document).trigger 'votes:destroyed', {data: data}