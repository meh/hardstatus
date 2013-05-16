hardstatus
==========
I use the GNU screen hardstatus as global status bar, the downside was I had
about 10 scripts that would make the whole thing lag every few seconds.

This solves the problem.

Install
-------
Just install the gem and build the binary helper by running `rake`, it will
put it in `bin/hardstatus`, you can them move it in your PATH and call it as
backtick in the hardstatus.

Assuming you renamed the binary to `hs`.

```
backtick 1 1 1 hs right
```

This will define a right backtick, you have then to hadd the backtick to the
hardstatus, supposedly on the right.

You can have both left and right templates in the configuration.

Example
-------

```ruby
right '#{irssi}#{email}#{hackers}#{processor}#{temperature}#{wireless}#{battery}'

def wrap (string)
	"\005{= r}[\005{+b W}#{string}\005{= dr}] "
end

backtick :irssi, every: 1.second do
	notifications = File.read(File.expand_path('~/.irssi/notifications')).gsub(':', '@').split(/, /)

	unless notifications.empty?
		wrap "IRC\005{-b r}|" + notifications.map {|n|
			"\005{+b rW}#{n}\005{-b dd}"
		}.join(' ')
	end
end

require 'json'
require 'socket'
require 'timeout'

backtick :email, every: 3.second do
	socket = TCPSocket.new('localhost', '9001')
	socket.puts '* list unread'

	notifications = JSON.parse(socket.gets)

	unless notifications.empty?
		wrap "Mail\005{-b r}|" + notifications.map {|name|
			"\005{+b rW}#{name}\005{-b dd}"
		}.join(' ')
	end
end

backtick :hackers, every: 5.seconds do
end

backtick :processor, every: 5.seconds do
	wrap `(cpupower -c 0 frequency-info; cpupower -c 1 frequency-info) |
		grep "current CPU" |
		head -n 1 |
		sed 's/^.*is //' |
		sed 's/\.$//' |
		tr -d '\n'`
end

backtick :temperature, every: 5.seconds do
	`sensors`.match(/temp1:\s+([\d+\-.]+)/) { |m|
		wrap(if m.to_i > 100
			'STACCA STACCA STACC-'
		else
			"#{m} C"
		end)
	}
end

backtick :wireless, every: 5.seconds do
	state = `iwconfig wlan0`

	next if state =~ /No such device/

	essid   = state.match(/ESSID:"(.*?)"/)[1]
	quality = state.match(/Quality=(.*?) /)[1]

	if quality
		wrap "#{essid}\005{-b r}|\005{+b W}#{quality}"
	end
end

backtick :battery, every: 5.seconds do
	state = `acpitool -B`

	next if state =~ /100\.0%/

	current = state.match(/([^\s]+%.*)$/)[1].sub(/, /, "\005{-b r}|\005{+b W}")

	if state.match(/discharging/)
		wrap "v|\005{+b W}#{current}"
	else
		wrap "^\005{-b r}|\005{+b W}#{current}"
	end
end
```

Why in the world would you do that?
-----------------------------------
Because life is too easy, and tmux handling of windows isn't compatible with my
workflow, so I have to deal with the shittiness of GNU screen and this makes it
both usable and useful to my end.
