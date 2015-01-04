class @commentService
	@create = (sourceId, text) ->
		$.ajax("/comments", method: 'POST', data: {comment : {source_id: sourceId, text: text}}).done (data) ->
			$(document).trigger 'comments:created', {comment: data.comment}

	@edit = (commentId, text) ->
		$.ajax("/comments/#{commentId}", method: 'PUT', data: {comment : {text: text}}).done (data) ->
			$(document).trigger 'comments:edited', {comment: data.comment}

	@destroy = (commentId) ->
		$.ajax("/votes/#{commentId}", method: 'DELETE').done (data) ->
			console.log data
			$(document).trigger 'comment:destroyed', {data: data}