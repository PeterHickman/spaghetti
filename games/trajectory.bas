10 REM A Fortran program to calculate a trajectory
20 let pi = 3.1415926535
30 let grav = 9.8
40 let x = 0
50 let y = 0
60 let xvel = 0
70 let yvel = 0
80 let vel = 0
90 let angle = 0
100 let time = 0
110 let timestep = 0
120 print "CALCULATE A TRAJECTORY"
130 print ""
140 input "ENTER THE VELOCITY: " vel
150 input "ENTER THE ANGLE: " angle
160 if vel >= 0 goto 190
170 print "VELOCITY CANNOT BE < ZERO"
180 goto 140
190 if (angle >= 0) and (angle < 180) goto 220
200 print "ANGLE MUST BE >= 0.0 AND < 180"
210 goto 150
220 print "vel=" vel
230 print "angle=" angle
240 let xvel = vel * cos(angle * pi/180.0)
250 let yvel = vel * sin(angle * pi/180.0)
260 print xvel " " yvel
270 print ""
280 input "ENTER TIMESTEP: " TIMESTEP
290 if timestep >= 0 goto 320
300 print "TIME CANNOT BE < ZERO"
310 goto 280
320 PRINT "OUTPUT IS TIME, X, Y, YVEL"
330 PRINT TIME " " X " " Y " " YVEL
340 let X = X + XVEL * TIMESTEP
350 let Y = Y + YVEL * TIMESTEP - 0.5 * GRAV * TIMESTEP * TIMESTEP
360 let YVEL = YVEL - GRAV * TIMESTEP
370 let TIME = TIME + TIMESTEP
380 PRINT TIME " " X " " Y " " YVEL
390 IF Y > 0.0 GOTO 340
400 PRINT "DONE"
410 end