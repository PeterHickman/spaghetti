10 REM Test the ABS function
20 let a = ABS(12)
30 let e = 12
40 gosub 80
50 let a = ABS(-12)
60 gosub 80
70 end
80 if a = e goto 110
90 print "Failed" a e
100 goto 120
110 print "Ok"
120 return