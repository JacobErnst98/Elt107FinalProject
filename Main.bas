
symbol rand = b1 ' random number store for loading memory
symbol value = b2 ' switch value 0-1-2-3
symbol playerstep = b3 ' position of player in game
symbol freq = b4 ' sound variable
symbol topstep = b5 ' number of steps in sequence
symbol counter = b6 ' general purpose counter
symbol speed = b7 ' speed

init:
let pinsB = %11111111 'set pins high
random rand 'random memmory
if pin3 = 1 then preload 
if pin2 = 1 then preload
if pin1 = 1 then preload
if pin0 = 1 then preload

goto init

preload:
low B.0
low B.1
low B.2
low B.3  ' LEDs off
for counter = 0 to 30 ' for..next loop
let value = 0
random rand ' get random number 0-255
if rand > 180 then set0
if rand > 120 then set1
if rand > 60 then set2
set3: let value = value + 1 '1+1+1 = 3
set2: let value = value + 1 '1+1 = 2
set1: let value = value + 1 '1
set0: '0
write counter,value ' save in data memory
next counter ' next loop

low B.0
low B.1
low B.2
low B.3  ' LEDs off
let topstep = 1 ' reset step number to 1
' playback the game sequence
playback:
speed = 2 ' speed value
for counter = 1 to topstep ' for...next loop
 read counter,value ' get value
 gosub beep ' make the noise
 pause 300 ' short delay
next counter ' loop
playerstep = 1
gameloop:
' if playerstep is greater than topstep then all done
if playerstep > topstep then success
' get the correct key value is supposed to hit
' from the EEPROM memory
read playerstep,value
' now wait for switch to be pressed
lp: pause 50
if pin3 = 1 then pushed0
if pin2 = 1 then pushed1
if pin1 = 1 then pushed2
if pin0 = 1 then pushed3
'SERTXD ("check button state", topstep)
goto lp

pushed0: SERTXD ("button",value)
if value <> 0 then fail
let playerstep = playerstep + 1
'SERTXD ("button",value)
gosub beep
goto gameloop
pushed1: SERTXD ("button",value)
if value <> 1 then fail
let playerstep = playerstep + 1
'SERTXD ("button",value)
gosub beep
goto gameloop
pushed2: SERTXD ("button",value)
if value <> 2 then fail
let playerstep = playerstep + 1
'SERTXD ("button",value)
gosub beep
goto gameloop
pushed3: SERTXD ("button",value)
if value <> 3 then fail
let playerstep = playerstep + 1
'SERTXD ("button",value)
gosub beep
goto gameloop

fail:
low B.0
low B.1
low B.2
low B.3 ' all LEDs off
sound C.4,(80,100) ' make a noise
sound C.4,(50,100)
goto init ' back to start

success:
pause 100 ' short delay
high B.0
high B.1
high B.2
high B.3 ' all LEDs on
if topstep = 1 then '2 on 7seg
high B.4
low B.5
low B.6
low B.7
endif
if topstep = 2 then '2 on 7seg
low B.4
high B.5
low B.6
low B.7
endif
if topstep = 3 then '2 on 7seg
high B.4
high B.5
low B.6
low B.7
endif
if topstep = 4 then'2 on 7seg
low B.4
low B.5
high B.6
low B.7
endif
if topstep = 5 then '2 on 7seg
high B.4
low B.5
high B.6
low B.7
endif
if topstep = 6 then '2 on 7seg
low B.4
high B.5
high B.6
low B.7
endif
if topstep = 7 then '2 on 7seg
high B.4
high B.5
high B.6
low B.7
endif
if topstep = 8 then '2 on 7seg
low B.4
low B.5
low B.6
high B.7
endif
if topstep = 9 then '2 on 7seg
high B.4
low B.5
low B.6
high B.7
endif
sound C.4,(120,50) 'success beep
low B.0
low B.1
low B.2
low B.3 ' all LEDs off
pause 100 ' short delay
if topstep = 10 then win
let topstep = topstep + 1 'add another step
goto playback ' loop again

beep:
high value ' switch on LED
freq = value + 1 ' generate sound freq.
freq = freq * 25
sound C.4,(freq,speed) ' play sound
low value ' switch off LED
return ' return
win:
for counter = 0 to 3
	high B.0
	high B.1
	high B.2
	high B.3
	pause 250
	low B.0
	low B.1
	low B.2
	low B.3
	pause 250
next
sound C.4,(90,25)
pause 50
sound C.4,(90,25)
pause 50
sound C.4,(120,50)
goto init
