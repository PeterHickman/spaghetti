10 REM Compare two values small and large
20 let a = 2
30 let b = 17
40 if a < b then 200
45 print "1. Failed" a "is not <" b
50 if a > b then 300
55 print "2. Ok"
60 if a <= b then 400
65 print "3. Failed" a "is not <= to" b
70 if a >= b then 500
75 print "4. Ok"
80 if a = b then 600
85 print "5. Ok"
90 if a <> b then 700
95 print "6. Failed" a "is not <> to" b
100 end
200 print "1. Ok"
210 goto 50
300 print "2. Failed" a "is not >" b
310 goto 60
400 print "3. Ok"
410 goto 70
500 print "4. Failed" a "is not >= to" b
510 goto 80
600 print "5. Failed" a "is not = to" b
610 goto 90
700 print "6. Ok"
710 goto 100
