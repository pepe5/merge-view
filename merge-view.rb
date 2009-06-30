# = Merge View pkg
#!< HashAsoc < Hash; def key...; def value...; end
#!< for k -> for k,v cleanup..
class HashPlus < Hash
  def min ()
    puts ">| min |: #{self.inspect}"
    min = {(self.keys) [0] => self [(self.keys) [0]] [0]}
    for k in self.keys do
      if ((min[(min .keys)[0]] .scan /\d+/) [0] .to_i) > ((self[k][0] .scan /\d+/) [0] .to_i) then
        min = {k=>self[k]}
      end; end
    min; end
  def fillupFrom (srcs);
    puts ">| fillup |: #{self.inspect}"
    for k,v in self do
      if v.size < 1 then self[k] << (srcs .find {|f| f.path==k}) .readline end
    end;
    puts "+| #{self.inspect}"
  end
end

class MoreSrcsFile #?<< File
  def m1 (kvp={}); p = {:k1=>'d1', :k2=>'d2'} .merge! kvp; puts "p:#{p.inspect}"; end
  attr :cache, :srcs
  def initialize (fds, modeString='r')
    @cache = HashPlus .new
    @srcs = fds .collect {|i| File .new i, modeString} end
  def readall (); @srcs .collect {|f| f .readlines} end
  def readline ();
    if @cache .size < 1 then @srcs .each {|f| @cache[f.path] = [f .readline]} end
    puts "@cache before min: #{@cache.inspect}"
    minCons = @cache .min
    o = @cache [(minCons .keys)[0]] .pop #&
    puts "poped: #{o.inspect}"
    puts "@cache after pop: #{@cache.inspect}}"
    @cache .fillupFrom @srcs
    puts "@cache after fillup: #{@cache.inspect}"
    o; end
end

puts ((myFiles = MoreSrcsFile .new ARGV) .readline)
# puts "cache: #{myFiles.cache .inspect}"
puts
puts ((myFiles) .readline)
# puts "cache: #{myFiles.cache .inspect}"
# puts "min (_by..):"
# myFiles .cache .min
