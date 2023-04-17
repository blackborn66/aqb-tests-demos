REM
REM Draw the famous Koch Curve
REM
REM from rosetta code FreeBASIC example
REM
REM for AQB by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT

REM SCREEN 1, 640, 512, 5, AS_MODE_HIRES OR AS_MODE_LACE, "Koch Curve Demo"
WINDOW 1, "Koch Curve Demo (Koch Snowflake)", (0,0) - (640, 500)

CLS

DIM SHARED AS Single Pi = 4 * Atn(1)
DIM SHARED AS Single RtoD = 180 / Pi
DIM SHARED AS Single DtoR = Pi / 180

DIM SHARED AS Single posX = 260, posY = 90, angle = 0
DIM SHARED AS Byte colr = 1

SUB drawEdge(length AS Single, level AS Integer)
    DIM AS Single dx, dy
    IF level = 0 THEN
        dx = Cos(angle*DtoR) * length
        dy = Sin(angle*DtoR) * length
        LINE (posX, posY)-(posX+dx, posY+dy), colr
        posX = posX + dx
        posY = posY + dy
    ELSE
        drawEdge length/3.0, level-1
        angle = angle + 60
        drawEdge length/3.0, level-1
        angle = angle - 120
        drawEdge length/3.0, level-1
        angle = angle + 60
        drawEdge length/3.0, level-1
    END IF
END SUB

SUB KochSnowflake(length AS Single, recursionlevel AS Integer)
    FOR i AS Integer = 1 TO 6
        drawEdge length, recursionlevel
        angle = angle - 300
    NEXT i
END SUB

FOR n AS Integer = 0 TO 5
    Cls
    colr = n + 1    
    Locate 3,4: PRINT "Koch Snowflake"
    Locate 4,4: PRINT "Iteration number: "; n
    KochSnowflake 200.0, n
    Sleep FOR 0.8
NEXT n

COLOR 4
LOCATE 56, 1
PRINT "PRESS ANY KEY TO QUIT"

WHILE INKEY$ = ""
    SLEEP
WEND
