REM
REM create an amazing maze
REM and an animated solution ...
REM
REM algorithms are from rosetta code bbc basic example
REM
REM for AQB by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT

SCREEN 1, 640, 240, 2, AS_MODE_HIRES, "Maze Demo"
WINDOW 1, "Maze Demo", (0,0) - (640, 200)

RANDOMIZE Fix(Timer()) * 1000

CONST AS INTEGER w = 13 : REM maze width
CONST AS INTEGER h = 13 : REM maze height
CONST AS INTEGER sy = 10 : REM cell width
CONST AS integer sx = 20 : REM cell height
CONST AS integer d = 10 : REM distance to border

CONST AS INTEGER p0x = 0 : REM start point for solution
CONST AS INTEGER p0y = 0 : REM start point for solution
CONST AS INTEGER p1x = w-1 : REM end point for solution
CONST AS INTEGER p1y = h-1 : REM end point for solution
REM DIM SHARED AS BOOLEAN f = FALSE : REM found the solution

DIM SHARED AS BYTE m ( w, h )
DIM SHARED AS BYTE t ( 2, w*h ) : REM the track for the solution
DIM SHARED AS INTEGER s = -1 : REM  steps walked

SUB ConnectCell(BYVAL x AS INTEGER, BYVAL y AS INTEGER)
    DIM AS INTEGER i, p, q, r
    m(x,y) = m(x,y) OR 4 : REM visited
    
    SLEEP FOR 0.02
    
    r = RND() * 4
    FOR i = r TO r+3
        SELECT CASE i MOD 4 
        CASE 0
            p = x-1
            q = y
        CASE 1
            p = x+1 
            q = y
        CASE 2
            p = x 
            q = y-1
        CASE 3
            p = x 
            q = y+1
        END SELECT
        IF p >= 0 AND p < w AND q >= 0 AND q < h THEN
            IF m(p,q) < 4 THEN
                IF p > x THEN 
                    m(p,q) = m(p,q) OR 1 
                    LINE (p*sx+d,y*sy+1+d) - (p*sx+d,(y+1)*sy-1+d), 0
                ENDIF                
                IF q > y THEN
                    m(p,q) = m(p,q) OR 2 
                    LINE (x*sx+1+d,q*sy+d) - ((x+1)*sx-1+d,q*sy+d), 0
                ENDIF                
                IF x > p THEN
                    m(x,y) = m(x,y) OR 1 
                    LINE (x*sx+d,y*sy+1+d) - (x*sx+d,(y+1)*sy-1+d), 0
                ENDIF                
                IF y > q THEN 
                    m(x,y) = m(x,y) OR 2
                    LINE (x*sx+1+d,y*sy+d) - ((x+1)*sx-1+d,y*sy+d), 0
                ENDIF                
                ConnectCell p, q
            ENDIF
        ENDIF
    NEXT
END SUB

SUB generatemaze
    LINE (d,d) - (w*sx+d, h*sy+d), 0, BF    
    DIM AS INTEGER x, y
    FOR y = 0 TO h - 1 
        FOR x = 0 TO w
            m(x,y) = 0
        NEXT
    NEXT
    FOR y = 0 TO h
        LINE (d,y*sy+d) - (w*sx+d,y*sy+d), 2
    NEXT
    FOR x = 0 TO w
        LINE (x*sx+d,d) - (x*sx+d, h*sy+d), 2
    NEXT
    CALL ConnectCell RND()*w-1, RND()*h-1
END SUB

SUB showcodes
    DIM AS INTEGER x, y
    FOR y = 0 TO h-1
        FOR x = 0 TO w-1 
            locate y+2, x*3+37
            PRINT m (x,y) AND 3
        NEXT x
    NEXT y
END SUB

SUB clearsolution
    DIM AS INTEGER x, y
    FOR y = 0 TO h - 1 
        FOR x = 0 TO w
            m(x,y) = m(x,y) AND 3
        NEXT
    NEXT
    REM f = FALSE
    s = -1 
    TRACE " ----- "    
    FOR y = 0 TO h-1
        FOR x = 0 TO w-1 
            IF (m(x,y ) AND 2) = 2 THEN
                LINE (x*sx+d+sx/2,y*sy-sy/2+d) - (x*sx+d+sx/2,y*sy+sy/2+d), 0
            ENDIF
            IF (m(x,y ) AND 1) = 1 THEN
                LINE (x*sx+d-sx/2,y*sy+sy/2+d) - (x*sx+d+sx/2,y*sy+sy/2+d), 0
            ENDIF
        NEXT x
    NEXT y
END SUB


SUB solution0
    DIM AS INTEGER x, y
    FOR y = 0 TO h-1
        FOR x = 0 TO w-1 
            IF (m(x,y ) AND 2) = 2 THEN
                LINE (x*sx+d+sx/2,y*sy-sy/2+d) - (x*sx+d+sx/2,y*sy+sy/2+d), 1
            ENDIF
            IF (m(x,y ) AND 1) = 1 THEN
                LINE (x*sx+d-sx/2,y*sy+sy/2+d) - (x*sx+d+sx/2,y*sy+sy/2+d), 1
            ENDIF
        NEXT x
    NEXT y
END SUB


SUB solution1
    DIM AS INTEGER x, y, i, n, p, q
    DIM AS BYTE c : REM color
    x = p0x
    y = p0y    
    m(x,y) = m(x,y) OR 4
    s = 0
    WHILE True
        sleep FOR 0.02
        FOR i = 0 TO 3
            SELECT CASE i
            CASE 0
                p = x-1 
                q = y
            CASE 1
                p = x+1
                q = y
            CASE 2
                p = x 
                q = y-1
            CASE 3
                p = x 
                q = y+1
            END SELECT
            IF p >= 0 AND p < w AND q >= 0 AND q < h THEN
                IF (m(p,q) AND 4) = 0 THEN
                    IF p > x AND (m(p,q) AND 1) = 1 THEN
                        EXIT FOR
                    ELSEIF q > y AND (m(p,q) AND 2) = 2 THEN
                        EXIT FOR
                    ELSEIF x > p AND (m(x,y) AND 1) = 1 THEN 
                        EXIT FOR
                    ELSEIF y > q AND (m(x,y) AND 2) = 2 THEN
                        EXIT FOR
                    ENDIF 
                ENDIF
            ENDIF                
        NEXT
        IF i < 4 THEN
            m(p,q) = m(p,q) OR 4
            t(0, s) = x
            t(1, s) = y
            s = s + 1
            c = 1
        ELSE
            IF s > 0 THEN
                s = s - 1
                p = t(0, s)
                q = t(1, s)
                c = 3
            ENDIF
        ENDIF
        LINE (x*sx+d+sx/2,y*sy+d+sy/2) - (p*sx+d+sx/2,q*sy+d+sy/2), c
        x = p
        y = q
        
        IF x = p1x AND y = p1y THEN
            REM f = true
            EXIT WHILE
        ENDIF
        
    WEND 
    t(0,s) = x
    t(1,s) = y
END SUB


generatemaze

LOCATE 22, 2
PRINT "Press 'Q' to quit or another (N, C, S, 1) for special functions!"


DIM AS STRING key 
WHILE TRUE
    key = INKEY$
    SELECT CASE key 
    CASE "q", "Q", "x", "X", chr$(27)
        system
    CASE "n", "N", "m", "M"
        generatemaze
    CASE "c", "C"
        showcodes
    CASE "s", "S", "0"
        clearsolution
        solution0        
    CASE "1"
        clearsolution
        solution1
    END SELECT
    
    sleep
WEND
