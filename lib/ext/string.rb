
require 'thefox-ext'

class String
	def is_valid?
		is_upper? || is_lower? || is_digit?
	end
end
