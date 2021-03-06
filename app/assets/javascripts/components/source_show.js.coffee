commentHTML = (text, username) ->
	'<div class="comment">' +
    '<div class="content">' +
      '<a class="author">' +
      	username + '</a>' +
		      '<div class="metadata">' +
		        '<span class="date"> - Now</span>' +
		      '</div>' +
		      '<div class="text">' +
		        text +
		      '</div>' +
		    '</div>' +
	    '</div>'

window.sourceShow.component = flight.component ->
	@attributes({
		sourceId: null,
		completedSelector: '#complete',
		upSelector: '#up',
		downSelector: '#down',
		addCommentBtn: '.new-comment-submit'
	})

	@after 'initialize', ->
		@on 'click', {
			completedSelector: @toggleCompleted,
			upSelector: -> @toggleVote(true),
			downSelector: -> @toggleVote(false),
			addCommentBtn: @addComment
		}
		@on document, 'completedSources:created', @setCompletedSourceId
		@on document, 'votes:created', @setVoteId

	@setCompletedSourceId = (e, data) ->
		console.log data
		@completedSourceId = data.completedSource.id

	@setVoteId = (e, data) ->
		console.log data
		@voteId = data.vote.id

	@toggleCompleted = (e) ->
		if $(e.target).attr('class').indexOf('active') > -1
			$(e.target).removeClass('active')
			@select('upSelector').addClass('disabled')
			@select('downSelector').addClass('disabled')
			if !!@voteId
				window.votesService.destroy(@voteId)
				@voteId = null
				@select('upSelector').removeClass('active')
				@select('downSelector').removeClass('active')
			window.completedSourcesService.destroy(@completedSourceId)
			@completedSourceId = null
		else
			$(e.target).addClass('active')
			@select('upSelector').removeClass('disabled')
			@select('downSelector').removeClass('disabled')
			window.completedSourcesService.create(@attr.sourceId)

	@addComment = (e) ->
		commentText = $('.new-comment').val()
		commentService.create(@attr.sourceId, commentText);
		commentContainer = $('.comment-container').append commentHTML(commentText, window.currentUser.username)
		$('.new-comment').val('')

	@toggleVote = (isUp) ->
		if !!@completedSourceId
			selector = if isUp then @attr.upSelector else @attr.downSelector
			otherSelector = if isUp then @attr.downSelector else @attr.upSelector
			if $(selector).attr('class').indexOf('active') > -1
				$(selector).removeClass('active')
				window.votesService.destroy(@voteId)
				@voteId = null
			else
				$(selector).addClass('active')
				$(otherSelector).removeClass('active')
				window.votesService.create(@attr.sourceId, isUp)