require 'rake/clean'

#define out common directories
base = Dir.getwd
listings = File.join(base,'listings')
reia = File.join(base,'reia')

#files to build
clone = File.join(listings,'clone.txt')
reia_dir = File.join(listings,'reia-dir.txt')
reia_build = File.join(listings,'reia-build.txt')
reia_install = File.join(listings,'reia-install.txt')

CLEAN.include "reia"
CLOBBER.include "listings/*"

task :default => [:reia, :clone]

task :clone => clone
task :reia => [reia_dir, reia_build, reia_install]

#simple minded method for splitting output, cannot handle files with spaces.
def tee(command, *files)
  files = files.join(' ') if files.respond_to?(:join)
  command = "#{command} 2>&1 | tee #{files}"
  sh command
end

file "listings" do |f|
  Dir.mkdir f.name
end

file clone => "listings" do |f|
  `rm -rf reia`
  tee "git clone https://github.com/tarcieri/reia.git", f.name
end

file reia_dir => :clone do |f|
  Dir.chdir reia
  tee 'ls -C', f.name
end

file reia_build => :clone do |f|
  Dir.chdir reia
  tee 'rake', f.name
end

file reia_install => reia_build do |f|
  Dir.chdir reia
  tee 'sudo rake install', f.name
end
