# = Merge View pkg -*- ruby -*-
# >! 1.9: //www.slideshare.net/bootstrap/co-nowego-w-wiecie-rubyego
# >! $-d and $stderr << ... --> log ...
# >! jruby java.time.parse
# >? could be #{def s .m a; expr; end} w/o "()"
class HashAsoc < Hash
  def key (); self .keys .first end
  def value (); self [self.key] end
end

class Line < String
  attr_accessor :path
  def initialize (str, path=nil, srcs=nil); super str; @path=path; @srcs=srcs end
  def lineno (); (@srcs .find {|f| f.path==@path}) .lineno end
end

class HashPlus < HashAsoc
  def initialize (srcs=nil); super
    srcs .each {|f| self[f.path] = [f .readline]} end

  @@b = lambda {|k,v| (v .first .scan /\d+/) [0] .to_i}
  def min_by (b=nil)
    b = (b) ? b : @@b
    min = HashAsoc .new; min [self.key] = self .value
    # puts "min value: #{min.value.inspect}"
    for i in self do
      k,v = i[0], i[1] #jrb < for k,v ..
      $-d and $stderr << "cache v: #{v.inspect}\n"
      maybe = b.call k,v
      orig = b.call min.key, min.value
      $-d and $stderr << "orig > maybe: #{[orig > maybe, ':', orig, '>', maybe] .inspect}\n"
      if orig > maybe then min = HashAsoc .new; min[k]=v end end
    # puts "<| min.."
    min end

  #>! move >| MoreSrcsFile
  def fillupFrom (srcs)
    for i in self do
      k,v = i[0], i[1] #jrb < for k,v ..
      # puts "fillup v: #{v.inspect}"
      begin
        if v.size < 1 then self[k] << (srcs .find {|f| f.path==k}) .readline end
      rescue EOFError
        (srcs .find {|f| f.path==k}) .close;
        $stderr << "file #{k} closed.\n"
        self .delete k
        if self.size < 1 then raise EOFError, "close that multi-file..", caller end
      end end end
end

class MoreSrcsFile #?, < File
  def m1 (kvp={}); p = {:k1=>'d1', :k2=>'d2'} .merge! kvp; puts "p:#{p.inspect}" end
  def readall (); @srcs .collect {|f| f .readlines} end

  attr_accessor :cache, :srcs, :criteria
  def initialize (fds, modeString='r')
    @srcs = fds .collect {|i| File .new i, modeString}
    @cache = HashPlus .new @srcs #>!? ini cache "value"/s -> Line obj/s?
    @criteria = nil end

  def readline ()
    @cache .fillupFrom @srcs
    minCons = @cache .min_by @criteria
    Line .new (@cache [minCons.key] .pop), minCons.key, @srcs end ###>! some built-in obj w/ fn+ln info (some file-cache..)?

  # < Enumerable //www.ruby-forum.com/topic/125914
  def next ()
    begin self .readline
    rescue EOFError; raise StopIteration end end
  def each (); loop {yield self.next} end # while true do... end
end

a = (defined? args) ? args : ARGV
myFiles = MoreSrcsFile .new a
require 'time' # +>! jruby java.time.parse
myFiles .criteria = proc {|k,v| (v .first .split "|") [0]}
format = proc \
{|l| a=l.split "|"; "#{a.first} \t @#{File.basename l.path}:#{l.lineno} \t #{a[1..a.size] .join "|"}"}
for l in myFiles do puts format .call l end
puts

### 

# timeBlockV () = proc \
# {|k,v|
#   t = (v .first .split "|") [0]
#   # $-d and $stderr << "call block: t: #{t.inspect}"
#   begin Time .parse t, (Time.now) #  if t =~ /[0-9:.]+/ then... else 0 end; # p 'time..'
#   rescue ArgumentError
#     $-d and $stderr << "call block: time not rec/d"
#     0 end }

# puts "cache: #{myFiles.cache .inspect}"
# puts "min (_by..):"
# myFiles .cache .min
