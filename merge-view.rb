# = Merge View pkg
#!< HashAsoc < Hash; def key...; def value...; end
class HashPlus < Hash
  def min ()
    min = {(self.keys) [0] => self [(self.keys) [0]] [0]}
    # p min
    for k in self.keys do
      # puts "#{k.inspect}: #{self [k][0] .inspect}"
      if ((min[(min .keys)[0]] .scan /\d+/) [0] .to_i) > ((self[k][0] .scan /\d+/) [0] .to_i) then
        min = {k=>self[k]}
      end; end
    min; end
  def fillupFrom (srcs);
    for k,v in self do
      if v.size < 1 then self[k] << (srcs .find {|f| f.path==k}) .readline end
    end
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
    minCons = @cache .min
    o = @cache [(minCons .keys)[0]] .pop #&
    @cache .fillupFrom @srcs
    o; end
end

puts ((myFiles = MoreSrcsFile .new ARGV) .readline)
puts "cache: #{myFiles.cache .inspect}"
puts ((myFiles = MoreSrcsFile .new ARGV) .readline)
puts "cache: #{myFiles.cache .inspect}"
# puts "min (_by..):"
# myFiles .cache .min
