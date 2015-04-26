Gem::Specification.new {|s|
	s.name         = 'hardstatus'
	s.version      = '0.0.2'
	s.author       = 'meh.'
	s.email        = 'meh@schizofreni.co'
	s.homepage     = 'http://github.com/meh/hardstatus'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'Hardstatus helpers for screen, because tmux just does not cut it for me.'

	s.files         = `git ls-files`.split("\n")
	s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
	s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
	s.require_paths = ['lib']

	s.add_runtime_dependency 'eventmachine'
	s.add_runtime_dependency 'thread'
}
