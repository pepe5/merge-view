# setup
PATH=/media/KINGSTON/opt/jruby-1.3.1/bin:$PATH
echo looking at: `pwd`
d=.bak/`date -Im | cut -d+ -f1 | tr : -`
old=.bak/`ls -1t .bak/ | grep 2009 | head -1`

# main
mkdir $d/
cp -v merge-view.rb $d/
diff -U1 $old/merge-view.rb merge-view.rb > $d/commit.diff

cmd="jruby --1.9 merge-view.rb 1 2"
echo "# $d" > $d/runit.io.log
echo "> $cmd" >> $d/runit.io.log
eval $cmd >> $d/runit.io.log 2>&1 &

# report
cat $d/commit.diff
cat $d/runit.io.log # async src not connected..
