task :default => :build

task :build do
	sh "#{ENV['CC'] || 'clang'} -O3 -o bin/hardstatus ext/hardstatus.c"
end
