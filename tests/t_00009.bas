10 REM Compare two values that are the same
20 let a = 5
30 let b = 5
40 if a < b then 200
45 print "Ok"
50 if a > b then 300
55 print "Ok"
60 if a <= b then 400
65 print "Failed" a "is not <= to" b
70 if a >= b then 500
75 print "Failed" a "is not >= to" b
80 if a = b then 600
85 print "Failed" a "is not = to" b
90 if a <> b then 700
95 print "Ok"
100 end
200 print "Failed" a "is not <" b
210 goto 50
300 print "Failed" a "is not >" b
310 goto 60
400 print "Ok"
410 goto 70
500 print "Ok"
510 goto 80
600 print "Ok"
610 goto 90
700 print "Failed" a "is not <> to" b
710 goto 100
