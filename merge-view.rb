# = Merge View pkg
class MoreSrcsFile #?<< File
  def m1 (kvp={}); p = {:k1=>'d1', :k2=>'d2'} .merge! kvp; puts "p:#{p.inspect}"; end
  def initialize (fds, modeString='r'); @srcs = fds .collect do |i| File .new i, modeString; end; end
  def readall (); @srcs .collect do |f| f .readlines; end; end
end

puts ((myFiles = MoreSrcsFile .new ARGV) .readall)
