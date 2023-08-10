10 REM IF ... GOSUB test
20 for i = 1 to 10
30 if i < 5 gosub 60
40 next i
50 end
60 print i "is less than 5"
70 return
