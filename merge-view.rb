# = Merge View pkg
class HashAsoc < Hash
  def key (); self .keys .first end
  def value (); self [self.key] end
end

class HashPlus < HashAsoc
  @@b = lambda {|k,v| (v .first .scan /\d+/) [0] .to_i}
  def min_by (&b)
    min = HashAsoc .new; min [self.key] = self .value .first
    for k,v in self do
      b = (b) ? b : @@b
      maybe = @@b.call k,v
      orig = @@b.call min.key, min.value
      if orig > maybe then min = HashAsoc .new; min[k]=v end end
    min end

  def fillupFrom (srcs)
    for k,v in self do
      begin if v.size < 1 then self[k] << (srcs .find {|f| f.path==k}) .readline end
      rescue EOFError
        (srcs .find {|f| f.path==k}) .close;
        puts $stderr << "file #{k} closed."
        self .delete k end end end
end

class MoreSrcsFile #?<< File
  def m1 (kvp={}); p = {:k1=>'d1', :k2=>'d2'} .merge! kvp; puts "p:#{p.inspect}" end
  def readall (); @srcs .collect {|f| f .readlines} end

  attr :cache, :srcs
  def initialize (fds, modeString='r')
    @cache = HashPlus .new
    @srcs = fds .collect {|i| File .new i, modeString} end

  def readline ()
    if @cache .size < 1 then @srcs .each {|f| @cache[f.path] = [f .readline]} end
    minCons = @cache .min_by {|k,v| (v .first .scan /\d+/) [0] .to_i}
    o = @cache [minCons.key] .pop #&
    @cache .fillupFrom @srcs
    o end
end

puts ((myFiles = MoreSrcsFile .new ARGV) .readline)
puts ((myFiles) .readline)
puts ((myFiles) .readline)

# puts "cache: #{myFiles.cache .inspect}"
# puts "min (_by..):"
# myFiles .cache .min
