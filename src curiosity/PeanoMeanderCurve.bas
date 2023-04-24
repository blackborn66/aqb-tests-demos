REM
REM Draw the famous Peano Meander Curve
REM
REM from rosetta code VBA example
REM
REM for AQB by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT

CONST WIDTH AS Integer = 81 'a power of 3 for a evenly spaced curve - next is 243

SUB Peano(BYVAL x AS Integer, BYVAL y AS Integer, BYVAL lg AS Integer, BYVAL i1 AS Integer, BYVAL i2 AS Integer)
    IF (lg = 1) THEN
        LINE -(x * 4 + 5, y * 4 + 5)
        EXIT SUB
    END IF
    lg = lg / 3
    Peano x + (2 * i1 * lg), y + (2 * i1 * lg), lg, i1, i2
    Peano x + ((i1 - i2 + 1) * lg), y + ((i1 + i2) * lg), lg, i1, 1 - i2
    Peano x + lg, y + lg, lg, i1, 1 - i2
    Peano x + ((i1 + i2) * lg), y + ((i1 - i2 + 1) * lg), lg, 1 - i1, 1 - i2
    Peano x + (2 * i2 * lg), y + (2 * (1 - i2) * lg), lg, i1, i2
    Peano x + ((1 + i2 - i1) * lg), y + ((2 - i1 - i2) * lg), lg, i1, i2
    Peano x + (2 * (1 - i1) * lg), y + (2 * (1 - i1) * lg), lg, i1, i2
    Peano x + ((2 - i1 - i2) * lg), y + ((1 + i2 - i1) * lg), lg, 1 - i1, i2
    Peano x + (2 * (1 - i2) * lg), y + (2 * i2 * lg), lg, 1 - i1, i2
END SUB


SCREEN 1, 640, 512, 5, AS_MODE_HIRES OR AS_MODE_LACE, "Peano Meander Curve Demo"
WINDOW 1, "Peano Meander Curve Demo", (0,0) - (640, 500)

PSET (5,5)
Peano 0, 0, WIDTH, 0, 0

COLOR 4
LOCATE 56, 1
PRINT "PRESS ANY KEY TO QUIT"

WHILE INKEY$ = ""
    SLEEP
WEND

