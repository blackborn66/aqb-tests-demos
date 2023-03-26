REM
REM show Conways Game of Life in a very simple way
REM 
REM by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT

SCREEN 1, 320, 200, 2, 0, "Conways Game of Life"
WINDOW 1, "Conways Game of Life"

LOCATE 12, 2
PRINT "Press mouse button to quit"

SUB doQuit
    SYSTEM
END SUB

ON MOUSE CALL doQuit
MOUSE ON

RANDOMIZE Fix(Timer()) * 1000

' confige the size of the playground
CONST AS integer w = 50
CONST AS integer h = 50

DIM AS BITMAP_t PTR bm = BITMAP(w, h, 2)

' two arrays to create the next step in life
DIM AS integer gol(2, w+2, h+2)
DIM AS integer source = 0
DIM AS integer target = 1

DIM AS integer x, y

' random start
FOR x = 1 TO w
    FOR y = 1 TO h
        gol(target, x, y) = cint(rnd())
    NEXT
NEXT

DO  
    ' switch target
    IF target = 0 THEN 
        source = 0
        target = 1
    ELSE
        source = 1
        target = 0
    END IF
    
    BITMAP OUTPUT bm
    cls
    
    FOR x = 1 TO w
        FOR y = 1 TO h
            DIM neighbours AS integer
            neighbours = gol(source, x - 1, y - 1) + gol(source, x , y - 1)
            neighbours = neighbours + gol(source, x + 1, y - 1)
            neighbours = neighbours + gol(source, x - 1, y) + gol(source, x + 1, y)
            neighbours = neighbours + gol(source, x - 1, y + 1)
            neighbours = neighbours + gol(source, x, y + 1) + gol(source, x + 1, y + 1)
            DIM AS integer was = gol(source, x, y)
            DIM AS integer n
            IF was =0 THEN
                IF neighbours = 3 THEN 
                    N =1 : ' life
                ELSE 
                    N =0 : ' death
                END IF 
            ELSE
                IF neighbours = 3  OR neighbours = 2 THEN
                    N =1 
                ELSE 
                    N =0
                END IF
            END IF                
            gol(target, x, y) = N
            pset (x, y), N
        NEXT
        ' copy the border cells for easy calculation
        gol(target, x, 0) = gol(target, x, h)
        gol(target, x, h+1) = gol(target, x, 1)
    NEXT
    FOR y = 1 TO h
        ' copy the border cells for easy calculation
        gol(target, 0, y) = gol(target, w, y)
        gol(target, w + 1, y) = gol(target, 1, y)
    NEXT    
    ' copy the border cells for easy calculation
    gol(target, 0, 0) = gol(target, w, h)
    gol(target, w + 1, 0) = gol(target, 1, h)
    gol(target, w + 1, h + 1) = gol(target, 1, 1)
    gol(target, 0, h + 1) = gol(target, w, 1)
    
    WINDOW OUTPUT 1
    PUT (10, 10), bm
    sleep FOR 0.02 : ' needed to notice the mouse click
LOOP

