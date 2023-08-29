10 REM Copied from http://www.vintage-basic.net/games.html
20 PRINT "TRAP"
30 PRINT "CREATIVE COMPUTING MORRISTOWN, NEW JERSEY"
40 PRINT
50 PRINT
70 LET G = 6
80 LET N = 100
90 REM TRAP
100 REM STEVE ULLMAN, 8-1-72
110 PRINT "I AM THINKING OF A NUMBER BETWEEN 1 AND " N
120 PRINT "TRY TO GUESS MY NUMBER. ON EACH GUESS,"
130 PRINT "YOU ARE TO ENTER 2 NUMBERS, TRYING TO TRAP"
140 PRINT "MY NUMBER BETWEEN THE TWO NUMBERS. I WILL"
150 PRINT "TELL YOU IF YOU HAVE TRAPPED MY NUMBER, IF MY"
160 PRINT "NUMBER IS LARGER THAN YOUR TWO NUMBERS, OR IF"
170 PRINT "MY NUMBER IS SMALLER THAN YOUR TWO NUMBERS."
180 PRINT "IF YOU WANT TO GUESS ONE SINGLE NUMBER, TYPE"
190 PRINT "YOUR GUESS FOR BOTH YOUR TRAP NUMBERS."
200 PRINT "YOU GET" G "GUESSES TO GET MY NUMBER."
210 LET X = RND(N) + 1
220 LET Q = 1
230 PRINT
240 PRINT "GUESS #" Q
250 INPUT A
260 INPUT B
270 IF A = B AND X = A GOTO 450
280 IF A <= B GOTO 300
290 GOSUB 410
300 IF A <= X AND X <= B GOTO 360
310 IF X < A GOTO 340
320 PRINT "MY NUMBER IS LARGER THAN YOUR TRAP NUMBERS."
330 GOTO 370
340 PRINT "MY NUMBER IS SMALLER THAN YOUR TRAP NUMBERS."
350 GOTO 370
360 PRINT "YOU HAVE TRAPPED MY NUMBER."
370 LET Q = Q + 1
371 IF Q < G GOTO 230
380 PRINT "SORRY, THAT'S " G " GUESSES. THE NUMBER WAS " X
390 PRINT
400 GOTO 460
410 LET R = A
420 LET A = B
430 LET B = R
440 RETURN
450 PRINT "YOU GOT IT!!!"
460 PRINT
470 PRINT "TRY AGAIN."
480 PRINT
490 GOTO 210
500 END
