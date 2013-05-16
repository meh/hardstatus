#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class Hardstatus

class Controller < EventMachine::Protocols::LineAndTextProtocol
	def initialize (hardstatus)
		super

		@hardstatus = hardstatus
	end

	def receive_line (line)
		send_line @hardstatus.render(line.strip.to_sym)

		close_connection_after_writing
	end

	def send_line (line)
		raise ArgumentError, 'the line already has a newline character' if line.include? "\n"

		send_data line.dup.force_encoding('BINARY') << "\r\n"
	end
end

end
