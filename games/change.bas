10 REM Copied from http://www.vintage-basic.net/games.html
20 PRINT " CHANGE"
30 PRINT " CREATIVE COMPUTING MORRISTOWN, NEW JERSEY"
40 PRINT
50 PRINT
60 PRINT
70 PRINT "I, YOUR FRIENDLY MICROCOMPUTER, WILL DETERMINE"
80 PRINT "THE CORRECT CHANGE FOR ITEMS COSTING UP TO $100."
90 PRINT
100 PRINT
110 PRINT "COST OF ITEM" ;
120 INPUT A
130 PRINT "AMOUNT OF PAYMENT" ;
140 INPUT P
150 let C = P - A
160 let M = C
170 IF C <> 0 THEN 200
180 PRINT "CORRECT AMOUNT, THANK YOU."
190 GOTO 610
200 IF C > 0 THEN 240
210 let sc = a - p
220 PRINT "SORRY, YOU HAVE SHORT-CHANGED ME $ " sc
230 GOTO 110
240 PRINT "YOUR CHANGE, $" C
250 let D = INT(C / 10)
260 IF D = 0 THEN 280
270 PRINT D "TEN DOLLAR BILL(S)"
280 let C = M - (D * 10)
290 let E = INT(C / 5)
300 IF E = 0 THEN 320
310 PRINT E "FIVE DOLLARS BILL(S)"
320 let C = M - (D * 10 + E * 5)
330 let F = INT(C)
340 IF F = 0 THEN 360
350 PRINT F "ONE DOLLAR BILL(S)"
360 let C = M - (D * 10 + E * 5 + F)
370 let C = C * 100
380 let N = C
390 let G = INT(C / 50)
400 IF G = 0 THEN 420
410 PRINT G "ONE HALF DOLLAR(S)"
420 let C = N - (G * 50)
430 let H = INT(C / 25)
440 IF H = 0 THEN 460
450 PRINT H "QUARTER(S)"
460 let C = N - (G * 50 + H * 25)
470 let I = INT(C / 10)
480 IF I = 0 THEN 500
490 PRINT I "DIME(S)"
500 let C = N - (G * 50 + H * 25 + I * 10)
510 let J = INT(C / 5)
520 IF J = 0 THEN 540
530 PRINT J "NICKEL(S)"
540 let C = N - (G * 50 + H * 25 + I * 10 + J * 5)
550 let K = INT(C + 0.5)
560 IF K = 0 THEN 580
570 PRINT K "PENNY(S)"
580 PRINT "THANK YOU, COME AGAIN."
590 PRINT
600 PRINT
610 GOTO 110
620 END
