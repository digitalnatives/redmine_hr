require '../source/deps'

DOM::Document.body << DOM::Element.new("div#main-menu")
DOM::Document.body << DOM::Element.new("div#main")

CurrentProfile = {}
CurrentUser    = {}
