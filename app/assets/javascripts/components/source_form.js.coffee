stepInputHTML = () ->
	stepCount = $('.source-step').length

	"<div class=\"source-step\">" +
	"<input type=\"hidden\" name=\"source[steps_attributes][][ordinal]\" value=\"#{stepCount}\" class=\"ordinal\"></input>" +
	"<div class=\"ui labeled input\">" +
	"<input data-validate=\"step\" placeholder=\"Step #{stepCount+1}\" type=\"text\" name=\"source[steps_attributes][][description]\" class=\"description\">" +
	"<div class=\"ui corner red large label remove-step\" title=\"Remove Step\"><i class=\"remove icon\">" +
	"</i></div></input></div></div>"

labelHTML = (obj, objTypeSingle, objTypePlural) ->
	"<span class=\"category ui label #{obj.label_colour}\">#{obj.name}" +
	"<i class=\"remove-label remove icon\"></i>" +
	"<input type=\"hidden\" name=\"source[source_#{objTypePlural}_attributes][][#{objTypeSingle}_id]\" value=\"#{obj.id}\" class=\"#{objTypeSingle}_id\">" +
	"</input></span>"

window.sourceForm.component = flight.component ->
	@attributes({
		removeLabelSelector: '.remove-label'
	})

	@after 'initialize', ->
		@initializeUI()
		@formEvents()

	@initializeUI = () ->
		$('#source_price').dropdown()
		$('.ui.checkbox').checkbox()
		$('.ui.accordion').accordion()

	@formEvents = ->
		@on 'keypress', (e) ->
			e.preventDefault() if e.keyCode == 13
		@on 'click', {
			removeLabelSelector: @removeLabel
		}
		@on document, 'typeahead:autocompleted', @addLabel

	@addLabel = (e, data, dataName) ->
		dataName = data.dataName if dataName == undefined
		nameToSingular = {
			'emotions': 'emotion',
			'categories': 'category'
		}
		if !@alreadyBeenAdded(data, nameToSingular[dataName])
			$labelContainer = $("##{dataName}-label-container")
			$labelContainer.append(labelHTML(data, nameToSingular[dataName], dataName))

	@alreadyBeenAdded = (obj, objType) ->
		labelVals = $.map $(".#{objType}_id"), (input) -> parseInt $(input).val()
		labelVals.indexOf(obj.id) > -1

	@removeLabel = (e, data) ->
		$(e.target).parents('.ui.label')[0].remove()


# ********* Form Validation *********

window.sourceForm.validate = (form) ->
	$.fn.form.settings.keyboardShortcuts = false
	$.fn.form.settings.rules.timeExpression = (s) ->
		# eg: 14-15 minutes; 10.5-12.5s; 8 days 
		return true if s == '' or s == null
		units = [
			's|second(s?)|sec(s?)',
			'm|minute(s?)|min(s?)',
			'h|hour(s?)',
			'd|day(s?)',
			'w|week(s?)',
			'month(s?)'
		].join("|")
		numberRange = "(\\d+(\\.\\d+)?(\\-\\d+(\\.\\d+)?)?\\s?)"
		matcher = new RegExp("#{numberRange}(#{units})\\s", "i")
		console.log matcher
		matcher.test "#{s} "

	$.fn.form.settings.rules.isImage = (s) ->
		formats = [
			'jpg', 'bmp', 'png', 'gif'
		].join("|")
		matcher = new RegExp(formats, "i")
		matcher.test s

	$(form).form({
	  time: {
	  	identifier: 'source_time_required'
		  rules: [
		  	{
		  		type: 'timeExpression',
		  		prompt: 'Time required must be a number or range plus unit of time. Examples: 12-15 minutes; 1.5 hours'
		  	}
		  ]
		},
	  title: {
	    identifier: 'source_title',
	    rules: [
	      {
	        type: 'empty',
	        prompt: 'Title required'
	      }
	    ]
	  },
	  url: {
	    identifier: 'source_url',
	    rules: [
	      {
	        type: 'empty',
	        prompt: 'URL required'
	      },
	      {
	        type: 'url',
	        prompt: 'Invalid URL'
	      }
	    ]
	  },
	  description: {
	    identifier: 'source_description',
	    rules: [
	      {
	        type: 'empty',
	        prompt: 'Description required'
	      }
	    ]
	  },
	  avatar: {
	    identifier: 'source_avatar',
	    rules: [
	      {
	        type: 'empty',
	        prompt: 'Upload an image'
	      },
	      {
	        type: 'isImage',
	        prompt: 'File must be a valid image (jpg, png, gif, or bmp)'
	      }
	    ]
	  }
	},
	{
		inline: true
	});
