10 REM Sort of check the RND function for 0.0 .. 1.0
20 let c = 0
30 for n = 1 to 1000
40 let r = rnd(0)
50 if r < 0 OR r > 1 goto 70
60 let c = c + 1
70 next n
80 if c = 1000 goto 110
90 print "Failed"
100 end
110 print "Ok"
120 end