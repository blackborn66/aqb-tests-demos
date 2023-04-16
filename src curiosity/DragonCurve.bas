REM
REM Draw the famous Dragon Curve
REM
REM from rosetta code BASIC example (QBasic)
REM
REM for AQB by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT

REM SCREEN 1, 640, 512, 5, AS_MODE_HIRES OR AS_MODE_LACE, "Dragon Curve Demo"
WINDOW 1, "Dragon Curve Demo", (0,0) - (640, 500)

CLS

DIM SHARED angle AS Single

SUB turn (degrees AS Single)
    angle = angle + degrees * 3.14159265 / 180
END SUB

SUB forward (length AS Single)
    LINE - STEP (cos(angle)*length, sin(angle)*length), 2
END SUB

SUB dragon (length AS Single, split AS Integer, d AS Single)
    IF split = 0 THEN
        forward length
    ELSE
        turn d * 45
        dragon length / 1.4142136, split - 1, 1
        turn -d * 90
        dragon length / 1.4142136, split - 1, -1
        turn d * 45
    END IF
END SUB


' Main program

angle = 0
PSET (150,180), 0
dragon 420, 12, 1

LOCATE 56, 1
PRINT "PRESS ANY KEY TO QUIT"

WHILE INKEY$ ( ) = ""
    SLEEP
WEND

