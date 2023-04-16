REM
REM Play the Chaos Game to generate interesting shapes using a semi-random process 
REM like the Sierpinski Triangle
REM
REM algorithms are from rosetta code freeBASIC example
REM
REM for AQB by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT

REM SCREEN 1, 640, 512, 5, AS_MODE_HIRES OR AS_MODE_LACE, "Chaos Game Demo"
WINDOW 1, "Chaos Game Demo", (0,0) - (640, 500)

CLS

RANDOMIZE Fix(Timer()) * 1000

CONST AS integer width = 620, height = 480
DIM AS long x, y, iteration, vertex

x = Int(Rnd * width)
y = Int(Rnd * height)

FOR iteration = 1 TO 120000
    vertex = Int(Rnd * 3) + 1
    
    SELECT CASE vertex
    CASE 1
        x = x / 2
        y = y / 2
    CASE 2
        x = (width/2) + ((width/2)-x) / 2
        y = height - (height-y) / 2
    CASE 3
        x = width - (width-x) / 2
        y = y / 2
    END SELECT
    
    Pset (x,y),vertex
NEXT iteration

LOCATE 52, 1
PRINT "PRESS ANY KEY TO QUIT"

WHILE INKEY$ ( ) = ""
    SLEEP
WEND
