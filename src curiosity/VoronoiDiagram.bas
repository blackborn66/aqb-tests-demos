REM
REM Draw the famous Voronoi Diagram
REM it´s horrible slow!
REM try it with lesser cells or more turbo cards
REM
REM for AQB by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT

CONST numCells AS INTEGER = 32
DIM SHARED AS INTEGER width = 310, height = 220
DIM SHARED AS SINGLE cx(numCells), cy(numCells)

SCREEN 1, 320, 240, 5, 0, "Voronoi Diagram"
WINDOW 1, "Voronoi Diagram",(0,0)-(320, 240) REM , AW_FLAG_SIMPLE_REFRESH OR AW_FLAG_BORDERLESS OR AW_FLAG_ACTIVATE OR AW_FLAG_REPORTMOUSE, 1

RANDOMIZE TIMER()

' create some random points
FOR n AS INTEGER = 1 TO numCells
    cx(n) = rnd() * (width - 10) + 5
    cy(n) = rnd() * (height - 10) + 5
    TRACE n, cx(n), cy(n)
NEXT n

FOR y AS INTEGER = 0 TO height - 1
    TRACE y    
    FOR x AS INTEGER = 0 TO width - 1
        DIM dMin AS SINGLE = width + height
        DIM cell AS INTEGER = 1
        
        ' this is the slow down part
        ' we need a better stragtegy to find the nearest point
        FOR n AS INTEGER = 1 TO numCells
            DIM d AS SINGLE = ((cx(n) - x) * (cx(n) - x) + (cy(n) - y) * (cy(n) - y)) ^ 0.5
            IF d < dmin THEN
                dmin = d
                cell = n
            END IF
        NEXT n
        
        PSET(x, y), cell - 1
    NEXT x
NEXT y

COLOR 1, 0, 2,  DRMD_COMPLEMENT
FOR n AS INTEGER = 1 TO numCells
    PSET(cx(n), cy(n)), 1
    REM    pset(cx(n)+1, cy(n)+1), 2    
NEXT n

WHILE inkey$ = ""
    sleep
WEND

