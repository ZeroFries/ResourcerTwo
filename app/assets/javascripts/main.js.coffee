# Define namespaces
window.sourceForm ||= {}
window.sourceList ||= {}
window.sourceSearch ||= {}
window.sourceShow ||= {}
window.typeAhead ||= {}

# Misc Functions
window.updateURL = (path) ->
	window.history.pushState({"html":$('body').html(),"pageTitle": 'source'},"", path)

$ ->