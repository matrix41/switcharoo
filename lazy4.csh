#! /bin/csh -f

foreach file ( *.edm )
  ~/switcharoo/switcharoo.pl $file plnmsinilim 0
  ~/switcharoo/switcharoo.pl $file plnorbsmaxlim 0
  ~/switcharoo/switcharoo.pl $file plnorbeccenlim 0
  ~/switcharoo/switcharoo.pl $file plnorblperlim 0
  ~/switcharoo/switcharoo.pl $file plnorbmethod rv
end
exit 0
