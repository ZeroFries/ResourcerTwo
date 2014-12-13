window.sourceList.component = flight.component ->
	@after 'initialize', ->
		@on document, 'sources:indexHTML', @setHTML

	@setHTML = (e, html) ->
		html = html.html
		@$node.html $(html).filter("##{@$node.attr('id')}").html()