10 PRINT "LITERATURE QUIZ"
20 PRINT "CREATIVE COMPUTING MORRISTOWN, NEW JERSEY"
30 PRINT
40 PRINT
50 PRINT
60 LET R = 0
70 PRINT "TEST YOUR KNOWLEDGE OF CHILDREN'S LITERATURE."
80 PRINT
90 PRINT "THIS IS A MULTIPLE-CHOICE QUIZ."
100 PRINT "TYPE A 1, 2, 3, OR 4 AFTER THE QUESTION MARK."
110 PRINT
120 PRINT "GOOD LUCK!"
130 PRINT
140 PRINT
150 PRINT "IN PINOCCHIO, WHAT WAS THE NAME OF THE CAT"
160 INPUT "1)TIGGER, 2)CICERO, 3)FIGARO, 4)GUIPETTO ?" A
170 IF A = 3 THEN 200
180 PRINT "SORRY...FIGARO WAS HIS NAME."
190 GOTO 220
200 PRINT "VERY GOOD! HERE'S ANOTHER."
210 LET R = R + 1
220 PRINT
230 PRINT
240 PRINT "FROM WHOSE GARDEN DID BUGS BUNNY STEAL THE CARROTS?"
250 INPUT "1)MR. NIXON'S, 2)ELMER FUDD'S, 3)CLEM JUDD'S, 4)STROMBOLI'S ?" A
260 IF A = 2 THEN 300
270 PRINT "TOO BAD...IT WAS ELMER FUDD'S GARDEN."
280 GOTO 310
290 PRINT "PRETTY GOOD!"
300 LET R = R + 1
310 PRINT
320 PRINT
330 PRINT "IN THE WIZARD OF OS, DOROTHY'S DOG WAS NAMED"
340 INPUT "1)CICERO, 2)TRIXIA, 3)KING, 4)TOTO ?" A
350 IF A = 4 THEN 380
360 PRINT "BACK TO THE BOOKS,...TOTO WAS HIS NAME."
370 GOTO 400
380 PRINT "YEA! YOU'RE A REAL LITERATURE GIANT."
390 LET R = R + 1
400 PRINT
410 PRINT
420 PRINT "WHO WAS THE FAIR MAIDEN WHO ATE THE POISON APPLE"
430 INPUT "1)SLEEPING BEAUTY, 2)CINDERELLA, 3)SNOW WHITE, 4)WENDY ?" A
440 IF A = 3 THEN 470
450 PRINT "OH, COME ON NOW...IT WAS SNOW WHITE."
460 GOTO 490
470 PRINT "GOOD MEMORY!"
480 LET R = R + 1
490 PRINT
500 PRINT
510 IF R = 4 THEN 560
520 IF R < 2 THEN 600
530 PRINT "NOT BAD, BUT YOU MIGHT SPEND A LITTLE MORE TIME"
540 PRINT "READING THE NURSERY GREATS."
550 END
560 PRINT "WOW! THAT'S SUPER! YOU REALLY KNOW YOUR NURSERY"
570 PRINT "YOUR NEXT QUIZ WILL BE ON 2ND CENTURY CHINESE"
580 PRINT "LITERATURE (HA, HA, HA)"
590 END
600 PRINT "UGH. THAT WAS DEFINITELY NOT TOO SWIFT. BACK TO"
610 PRINT "NURSERY SCHOOL FOR YOU, MY FRIEND."
620 END