10 print "I am thinking of a number between 1 and 100"
20 print "You have 10 guesses to find it. Lets us begin..."
30 let s = rnd(100)
40 let c = 0
50 print ""
60 input "Enter a number" g
70 if g = s goto 180
80 if g < s gosub 140
90 if g > s gosub 160
100 let c = c + 1
110 if c = 10 goto 200
120 print "Have another go"
130 goto 50
140 print "Too low"
150 return
160 print "Too high"
170 return
180 print "Correct, you guessed the number was" s "in" c "goes"
190 end
200 print "You have run out of goes. Better luck next time"
210 end