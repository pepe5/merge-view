# = Merge View pkg
class HashPlus < Hash
  def min_by ();
        # puts @each .keys {|i| }
  end
end

class MoreSrcsFile #?<< File
  def m1 (kvp={}); p = {:k1=>'d1', :k2=>'d2'} .merge! kvp; puts "p:#{p.inspect}"; end
  def initialize (fds, modeString='r')
    @cache = HashPlus .new
    @srcs = fds .collect {|i| File .new i, modeString}; end
  def readall (); @srcs .collect {|f| f .readlines}; end
  def readline ();
    if @cache .size < 1 then @srcs .each {|f| @cache[f.path] = [f .readline]} end
    o = @cache [(@cache .keys) [1]] .pop
    o; end
end

puts ((myFiles = MoreSrcsFile .new ARGV) .readline)
