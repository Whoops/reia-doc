require 'rake/clean'
require_relative('ire')

#define out common directories
BASE = Dir.getwd
LISTINGS = File.join(BASE,'listings')
REIA = File.join(BASE,'reia')

#files to build
clone = File.join(LISTINGS,'clone.txt')
reia_dir = File.join(LISTINGS,'reia-dir.txt')
reia_build = File.join(LISTINGS,'reia-build.txt')
reia_system_install = File.join(LISTINGS,'reia-system-install.txt')
reia_local_install = File.join(LISTINGS,'reia-local-install.txt')
ire_init = File.join(LISTINGS,'ire-init.txt')

CLEAN.include "reia"
CLOBBER.include "listings/*"

task :default => [:reia, :clone, :examples]

task :clone => clone
task :reia => [reia_dir, reia_build, reia_local_install, reia_system_install]

def output_file(src)
  'listings/' + File.basename(src) + '.out'
end


EXAMPLES_SRC = FileList.new('examples/*.ire')
EXAMPLES_OUT = EXAMPLES_SRC.to_a.collect { |f| output_file(f) }

task :examples => EXAMPLES_OUT

#simple minded method for splitting output, cannot handle files with spaces.
def tee(command, *files)
  files = files.join(' ') if files.respond_to?(:join)
  command = "#{command} 2>&1 | tee #{files}"
  sh command
end

directory "listings" do |f|
  Dir.mkdir f.name
end

file clone => 'listings' do |f|
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

file reia_local_install => reia_build do |f|
  Dir.chdir reia
  home = File.expand_path('~/')
  ENV['REIA_BIN_DIR'] = File.join(home, ".reia", "bin")
  libs = File.join(home,'.reia','lib')
  sh "mkdir -p #{libs}"
  ENV['ERL_LIB_DIR'] = libs
  tee 'rake install', f.name
end

file reia_system_install => reia_build do |f|
  Dir.chdir reia
  tee 'sudo rake install', f.name
end

EXAMPLES_SRC.to_a.each do |ex|
  file output_file(ex) => [ex, ire_init] do |f|
    File.open(f.name, 'w') do |out|
      File.open(ex, 'r') do |src|
        Ire.open do |ire|
          src.each do |line|
            out << ire.command(line.chomp)
          end
        end
      end
    end
    
    puts "#{f.name} => #{ex}"
  end
end
