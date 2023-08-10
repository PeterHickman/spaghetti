10 REM Test the INT funtion
20 let f = 1.0
30 gosub 170
40 let f = 1.4
50 gosub 170
60 let f = 1.5
70 gosub 170
80 let f = 1.7
90 gosub 170
100 let f = 1.9999
110 gosub 170
120 let f = 1.9999999999
130 gosub 170
140 let f = 2.0000001
150 gosub 170
160 end
170 let i = int(f)
180 if i = 1.0 goto 210
190 print "Failed"
200 goto 220
210 print "Ok"
220 return
