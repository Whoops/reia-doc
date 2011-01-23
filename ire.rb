require 'pty'
require 'expect'

class Ire
  IRE_PROMPT = /(>>|\.\.)/

  def initialize()
    @read, @write, @pid = PTY.spawn('ire')
  end

  def init()
    text, @prompt = @read.expect(IRE_PROMPT)
    @init = true
  end
  

  def command(comm)
    init unless @init
    res = @prompt
    @write << comm
    @write << "\n"
    text, @prompt = @read.expect(IRE_PROMPT)
    res = "#{res} #{text.chomp(@prompt)}"
  end

  def stop()
    @write << "System.halt()\n"
    Process.wait(@pid)
  end

  def self.open
    ire = self.new
    ire.init
    yield ire
    ire.stop
  end  
end
