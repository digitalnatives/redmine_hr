require '../source/deps'

DOM::Document.body << DOM::Element.new("div#main-menu")
DOM::Document.body << DOM::Element.new("div#main")

CurrentProfile = {}
module CurrentUser
	class << self
		attr_accessor :admin

		def []
			self.admin
		end
	end
end
