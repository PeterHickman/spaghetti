10 REM Copied from http://www.vintage-basic.net/games.html
20 PRINT " ACEY DUCEY CARD GAME"
30 PRINT " CREATIVE COMPUTING MORRISTOWN, NEW JERSEY"
40 PRINT
50 PRINT
60 PRINT "ACEY-DUCEY IS PLAYED IN THE FOLLOWING MANNER "
70 PRINT "THE DEALER (COMPUTER) DEALS TWO CARDS FACE UP"
80 PRINT "YOU HAVE AN OPTION TO BET OR NOT BET DEPENDING"
90 PRINT "ON WHETHER OR NOT YOU FEEL THE CARD WILL HAVE"
100 PRINT "A VALUE BETWEEN THE FIRST TWO."
110 PRINT "IF YOU DO NOT WANT TO BET, INPUT A 0"
120 LET N = 100
130 LET Q = 100
140 PRINT "YOU NOW HAVE" Q "DOLLARS."
150 PRINT
160 GOTO 210
170 LET Q = Q + M
180 GOTO 140
190 LET Q = Q - M
200 GOTO 140
210 PRINT "HERE ARE YOUR NEXT TWO CARDS: "
220 LET A = RND(13) + 2
230 IF A < 2 THEN 220
240 IF A > 14 THEN 220
250 LET B = RND(13) + 2
260 IF B < 2 THEN 250
270 IF B > 14 THEN 250
280 IF A >= B THEN 220
290 IF A < 11 THEN 340
300 IF A = 11 THEN 360
310 IF A = 12 THEN 380
320 IF A = 13 THEN 400
330 IF A = 14 THEN 420
340 PRINT A
350 GOTO 430
360 PRINT "JACK"
370 GOTO 430
380 PRINT "QUEEN"
390 GOTO 430
400 PRINT "KING"
410 GOTO 430
420 PRINT "ACE"
430 IF B < 11 THEN 480
440 IF B = 11 THEN 500
450 IF B = 12 THEN 520
460 IF B = 13 THEN 540
470 IF B = 14 THEN 560
480 PRINT B
490 GOTO 580
500 PRINT "JACK"
510 GOTO 580
520 PRINT "QUEEN"
530 GOTO 580
540 PRINT "KING"
550 GOTO 580
560 PRINT "ACE"
570 PRINT
580 PRINT
590 INPUT "WHAT IS YOUR BET" M
600 IF M <> 0 THEN 640
610 PRINT "CHICKEN!!"
620 PRINT
630 GOTO 210
640 IF M <= Q THEN 680
650 PRINT "SORRY, MY FRIEND, BUT YOU BET TOO MUCH."
660 PRINT "YOU HAVE ONLY " Q " DOLLARS TO BET."
670 GOTO 580
680 LET C = RND(13) + 2
690 IF C < 2 THEN 680
700 IF C > 14 THEN 680
710 IF C < 11 THEN 760
720 IF C = 11 THEN 780
730 IF C = 12 THEN 800
740 IF C = 13 THEN 820
750 IF C = 14 THEN 840
760 PRINT C
770 GOTO 860
780 PRINT "JACK"
790 GOTO 860
800 PRINT "QUEEN"
810 GOTO 860
820 PRINT "KING"
830 GOTO 860
840 PRINT "ACE"
850 PRINT
860 IF C > A THEN 880
870 GOTO 910
880 IF C >= B THEN 910
890 PRINT "YOU WIN!!!"
900 GOTO 170
910 PRINT "SORRY, YOU LOSE"
920 IF M < Q THEN 190
930 PRINT
940 PRINT
950 PRINT "SORRY, FRIEND, BUT YOU BLEW YOUR WAD."
960 PRINT
970 PRINT
980 INPUT "TRY AGAIN (1=YES OR 0=NO)" A
990 PRINT
1000 PRINT
1010 IF A = 1 THEN 130
1020 PRINT "O.K., HOPE YOU HAD FUN!"
1030 END
