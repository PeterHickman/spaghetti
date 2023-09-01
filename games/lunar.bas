10 PRINT "LUNAR"
20 PRINT "CREATIVE COMPUTING MORRISTOWN, NEW JERSEY"
40 PRINT
50 PRINT
60 PRINT "THIS IS A COMPUTER SIMULATION OF AN APOLLO LUNAR"
70 PRINT "LANDING CAPSULE."
80 PRINT
90 PRINT
100 PRINT "THE ON-BOARD COMPUTER HAS FAILED (IT WAS MADE BY"
110 PRINT "XEROX) SO YOU HAVE TO LAND THE CAPSULE MANUALLY."
120 PRINT
130 PRINT "SET BURN RATE OF RETRO ROCKETS TO ANY VALUE BETWEEN"
140 PRINT "0 (FREE FALL) AND 200 (MAXIMUM BURN) POUNDS PER SECOND."
150 PRINT "SET NEW BURN RATE EVERY 10 SECONDS."
160 PRINT
170 PRINT "CAPSULE WEIGHT 32,500 LBS; FUEL WEIGHT 16,500 LBS."
180 PRINT
190 PRINT
200 PRINT
210 PRINT "GOOD LUCK"
220 LET L = 0
230 LET A = 120
240 LET V = 1
250 LET M = 33000
260 LET N = 16500
270 LET G = 0.001
280 LET Z = 1.8
290 LET A1 = INT(A)
300 LET A2 = INT(5280 * (A - A1))
310 LET A3 = 3600 * V
320 LET A4 = M - N
330 PRINT "SEC=" L " MI+FT=" A1 " MPH=" A2 " LB FUEL=" A3 " BURN RATE=" A4
340 PRINT
350 INPUT "BURN (0-200): " K
360 LET T = 10
370 LET A1 = M - N
380 IF A1 < 0.001 GOTO 500
390 IF T < 0.001 GOTO 290
400 LET S = T
410 LET A1 = N + S * K
420 IF M >= A1 GOTO 440
430 LET S = (M - N) / K
440 GOSUB 900
450 IF I <= 0 GOTO 760
460 IF V <= 0 GOTO 480
470 IF J < 0 GOTO 820
480 GOSUB 700
490 GOTO 370
500 PRINT "FUEL OUT AT " L " SECONDS"
510 LET S = (-V + SQR(V * V + 2 * A * G)) / G
520 LET V = V + G * S
530 LET L = L + S
540 LET W = 3600 * V
550 PRINT "ON MOON AT " L " SECONDS - IMPACT VELOCITY " W " MPH"
560 IF W > 1.2 GOTO 590
570 PRINT "PERFECT LANDING!"
580 END
590 IF W <= 10 GOTO 620
600 PRINT "GOOD LANDING (COULD RE BETTER)"
610 END
620 IF W > 60 GOTO 660
630 PRINT "CRAFT DAMAGE... YOU'RE STRANDED HERE UNTIL A RESCUE"
640 PRINT "PARTY ARRIVES. HOPE YOU HAVE ENOUGH OXYGEN!"
650 END
660 PRINT "SORRY THERE NERE NO SURVIVORS. YOU BLOW IT!"
670 LET A1 = W * 0.227
680 PRINT "IN FACT, YOU BLASTED A NEW LUNAR CRATER" A1 "FEET DEEP!"
690 END
700 LET L = L + S
710 LET T = T - S
720 LET M = M - S * K
730 LET A = I
740 LET V = J
750 RETURN
760 IF S < 0.005 GOTO 540
770 LET D = V + SQR(V * V + 2 * A * (G - Z * K / M))
780 LET S = 2 * A / D
790 GOSUB 900
800 GOSUB 700
810 GOTO 760
820 LET W =(1 - M * G / (Z * K)) / 2
830 LET S = M * V / (Z * K * (W + SQR(W * W + V / Z))) + 0.05
840 GOSUB 900
850 IF I <= 0 GOTO 760
860 GOSUB 700
870 IF J > 0 GOTO 370
880 IF V > 0 GOTO 820
890 GOTO 370
900 LET Q = S * K / M
910 LET J = V + G * S + Z * (-Q - Q * Q / 2 - Q ^ 3 / 3 - Q ^ 4 / 4 - Q ^ 5 / 5)
920 LET I = A - G * S * S / 2 - V * S + Z * S * (Q / 2 + Q ^ 2 / 6 + Q ^ 3 / 12 + Q ^ 4 / 20 + Q ^ 5 / 30)
930 RETURN