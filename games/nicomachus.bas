10 REM Copied from http://www.vintage-basic.net/games.html
20 PRINT "NICOMA"
30 PRINT "CREATIVE COMPUTING MORRISTOWN, NEW JERSEY"
40 PRINT
50 PRINT
60 PRINT
70 PRINT "BOOMERANG PUZZLE FROM ARITHMETICA OF NICOMACHUS -- A.D. 90!"
80 PRINT
90 PRINT "PLEASE THINK OF A NUMBER BETWEEN 1 AND 100."
100 PRINT
110 INPUT "YOUR NUMBER DIVIDED BY 3 HAS A REMAINDER OF" A
120 INPUT "YOUR NUMBER DIVIDED BY 5 HAS A REMAINDER OF" B
130 INPUT "YOUR NUMBER DIVIDED BY 7 HAS A REMAINDER OF" C
140 PRINT
150 PRINT "LET ME THINK A MOMENT..."
160 PRINT
170 LET D = 70 * A + 21 * B + 15 * C
180 IF D <= 105 THEN 210
190 LET D = D - 105
200 GOTO 180
210 PRINT "YOUR NUMBER WAS" D "RIGHT"
220 INPUT "(YES=1 NO=0)" A
230 IF A = 1 THEN 270
240 IF A = 0 THEN 290
250 PRINT "EH? I DON'T UNDERSTAND" A " TRY 1 FOR YES OR 0 FOR NO"
260 GOTO 220
270 PRINT "HOW ABOUT THAT!!"
280 GOTO 300
290 PRINT "I FEEL YOUR ARITHMETIC IS IN ERROR."
300 PRINT
310 PRINT "LET'S TRY ANOTHER."
320 GOTO 80
330 END