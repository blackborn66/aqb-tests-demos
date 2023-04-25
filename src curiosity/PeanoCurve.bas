REM
REM Draw the famous (serpentine) Peano Curve
REM L-System approach
REM
REM from an example in Delphi
REM https://entwickler-ecke.de/viewtopic.php?t=31981
REM
REM for AQB by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT

DIM SHARED init AS String = "X"
DIM SHARED genX AS String = "XFYFX+F+YFXFY-F-XFYFX"
DIM SHARED genY AS String = "YFXFY-F-XFYFX+F+YFXFY"

DIM SHARED AS Single dist, oldx, oldy
DIM SHARED AS Byte dep
DIM SHARED AS Integer dirx, diry

SUB Peano(BYVAL com AS String, BYVAL Level AS Integer)
    DIM i, a AS Integer
    DIM x, y AS Single
    
    FOR i = 1 TO LEN(com)
        SELECT CASE mid$(com, i, 1)
        CASE "X"
            IF Level > 0 THEN 
                Peano genX, Level-1
            END IF
        CASE "Y"
            IF Level > 0 THEN 
                Peano genY, Level-1
            END IF
        CASE "F"
            x = oldx + dist * dirx
            y = oldy + dist * diry 
            LINE -(x, y)
            ' Image1.Canvas.LineTo(Round(x),Round(y));
            oldx = x
            oldy = y 
        CASE "+"
            a = dirx 
            dirx = diry
            diry = -a
        CASE "-"
            a = diry 
            diry = dirx 
            dirx = -a
        END SELECT
    NEXT i
END SUB

SCREEN 1, 640, 512, 5, AS_MODE_HIRES OR AS_MODE_LACE, "Peano Curve Demo"
WINDOW 1, "Peano Curve Demo", (0,0) - (640, 500)

dirx = 1
diry = 0
dep = 5 ' iteration depth
dist = 484
oldx = 2 ' border
oldy = dist + oldx
dist = dist / (exp(dep * log(3)) - 1)
PSET(oldx, oldy)
Peano init, dep

COLOR 4
LOCATE 56, 1
PRINT "PRESS ANY KEY TO QUIT"

WHILE INKEY$ = ""
    SLEEP
WEND
