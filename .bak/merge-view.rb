# = Merge View pkg -*- ruby -*-
# >! 1.9: //www.slideshare.net/bootstrap/co-nowego-w-wiecie-rubyego
# +> test on jruby
# >? could be #{def s .m a; expr; end} w/o "()"
class HashAsoc < Hash
  def key (); self .keys .first end
  def value (); self [self.key] end
end

class HashPlus < HashAsoc
  @@b = lambda {|k,v| (v .first .scan /\d+/) [0] .to_i}
  def min_by (b=nil)
    b = (b) ? b : @@b
    min = HashAsoc .new; min [self.key] = self .value .first
    # puts "min value: #{min.value.inspect}"
    for k,v in self do
      # puts "cache v: #{v.inspect}"
      maybe = b.call k,v
      orig = b.call min.key, min.value
      # puts "orig > maybe: #{[orig > maybe, ':', orig, '>', maybe] .inspect}"
      if orig > maybe then min = HashAsoc .new; min[k]=v end end
    # puts "<| min.."
    min end

  def fillupFrom (srcs)
    for k,v in self do
      begin
        if v.size < 1 then self[k] << (srcs .find {|f| f.path==k}) .readline end
      rescue EOFError
        (srcs .find {|f| f.path==k}) .close;
        puts $stderr << "file #{k} closed."
        self .delete k
        if self.size < 1 then raise EOFError, "close that multi-file..", caller end
      end end end
end

class MoreSrcsFile #?, < File
  def m1 (kvp={}); p = {:k1=>'d1', :k2=>'d2'} .merge! kvp; puts "p:#{p.inspect}" end
  def readall (); @srcs .collect {|f| f .readlines} end

  attr_accessor :cache, :srcs, :criteria
  def initialize (fds, modeString='r')
    @cache = HashPlus .new
    @srcs = fds .collect {|i| File .new i, modeString}
    @criteria = nil end

  def readline ()
    #>! redefine after initialization!
    if @cache .size < 1 then @srcs .each {|f| @cache[f.path] = [f .readline]} end
    @cache .fillupFrom @srcs
    minCons = @cache .min_by @criteria
    # puts 'readline pop..'
    @cache [minCons.key] .pop end

  # < Enumerable //www.ruby-forum.com/topic/125914
  def next ()
    begin self .readline
    rescue EOFError; raise StopIteration end end
  def each (); loop { yield self.next } end # while true do... end
end

a = (defined? args) ? args : ARGV
myFiles = MoreSrcsFile .new a
require 'time'
myFiles .criteria = proc \
{|k,v|
  t = (v .first .split "|") [0] # puts "t: #{t.inspect}"
  begin Time .parse t, (Time.now) #  if t =~ /[0-9:.]+/ then... else 0 end; # p 'time..'
  rescue ArgumentError; Time .at 0 end
}

for l in myFiles do puts l end
puts
# puts "cache: #{myFiles.cache .inspect}"
# puts "min (_by..):"
# myFiles .cache .min
