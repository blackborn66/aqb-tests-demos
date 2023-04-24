REM
REM Draw the famous Hilbert Curve
REM
REM from rosetta code QB64 example
REM
REM for AQB by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT

DIM SHARED AS INTEGER sw, sh, wide, cell

SUB Hilbert (x AS INTEGER, y AS INTEGER, lg AS INTEGER, p AS INTEGER, q AS INTEGER)
    DIM AS INTEGER iL, iX, iY
    iL = lg: iX = x: iY = y
    IF iL = 1 THEN
        LINE -((wide - iX) * cell, (wide - iY) * cell)
        EXIT SUB
    END IF
    iL = iL \ 2
    Hilbert iX + p * iL, iY + p * iL, iL, p, -q + 1
    Hilbert iX + q * iL, iY + (-q + 1) * iL, iL, p, q
    Hilbert iX + (-p + 1) * iL, iY + (-p + 1) * iL, iL, p, q
    Hilbert iX + (-q + 1) * iL, iY + q * iL, iL, -p + 1, q
    REM sleep FOR 0.02    
END SUB


SCREEN 1, 640, 512, 5, AS_MODE_HIRES OR AS_MODE_LACE, "Hilbert Curve Demo"
WINDOW 1, "Hilbert Curve Demo", (0,0) - (640, 500)

wide = 128: cell = 3
sw = wide * cell + cell
sh = sw

DIM w AS integer = 4 

WHILE w <= wide
    cls
    
    PSET (wide * cell, wide * cell)
    Hilbert 0, 0, w, 0, 0
    
    w = w * 2
    IF w > wide THEN
        EXIT WHILE
    END IF
    
    LOCATE 56, 1
    PRINT "PRESS ANY KEY TO CONTINUE"
    
    WHILE inkey$ = ""
        sleep
    WEND
WEND    

COLOR 4
LOCATE 56, 1
PRINT "PRESS ANY KEY TO QUIT"

WHILE INKEY$ = ""
    SLEEP
WEND
