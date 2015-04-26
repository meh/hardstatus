#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'thread/every'
require 'eventmachine'

require 'hardstatus/time'
require 'hardstatus/controller'

class Hardstatus
	def self.load (path)
		Hardstatus.new.load(path)
	end

	attr_reader :right, :left

	def initialize
		@backticks = {}
		@controller = File.expand_path('~/.hardstatus.ctl')

		@left  = ""
		@right = ""
	end

	def load (path = nil, &block)
		if path
			instance_eval File.read(File.expand_path(path)), path, 1
		else
			instance_exec(&block)
		end

		self
	end

	def start
		return if started?

		@started = true

		File.umask(0).tap {|old|
			begin
				@signature = EM.start_server(@controller, Controller, self)
			ensure
				File.umask(old)
			end
		}
	end

	def started?
		@started
	end

	def stop
		return unless started?

		if @signature
			EM.stop_server @signature
		end

		@started = false
	end

	def controller (path)
		@controller = path
	end

	def right (template)
		@right = template
	end

	def left (template)
		@left = template
	end

	def backtick (name, options = {}, &block)
		@backticks[name] = Thread.every(options[:every] || 1, &block)
	end

	def render (side)
		instance_variable_get(:"@#{side}").gsub(/\#{.*?}/) { |m|
			if backtick = @backticks[m.match(/\#{(.*?)}/)[1].to_sym]
				backtick.value!.to_s
			end
		}
	end
end
