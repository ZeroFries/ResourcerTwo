class @completedSourcesService
	@create = (sourceId) ->
		$.ajax("/completed_sources", method: 'POST', data: {completed_source : {source_id: sourceId}}).done (data) ->
			$(document).trigger 'completedSources:created', {completedSource: data.completed_source}

	@destroy = (completedSourceId) ->
		$.ajax("/completed_sources/#{completedSourceId}", method: 'DELETE').done (data) ->
			console.log data
			$(document).trigger 'completedSources:destroyed', {data: data}