#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class Fixnum
	def seconds
		self
	end

	alias second seconds
	alias s seconds

	def milliseconds
		self / 1000
	end

	alias millisecond milliseconds
	alias ms milliseconds

	def minutes
		self * 60
	end

	alias minute minutes

	def hours
		self * 60 * 60
	end

	alias hour hours

	def days
		self * 60 * 60 * 24
	end

	alias day days
end

module Kernel
	def second
		1.second
	end

	def minute
		1.minute
	end

	def hour
		1.hour
	end

	def day
		1.day
	end
end
