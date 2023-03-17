REM
REM create a simple generative design
REM 
REM by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT

REM PAL Amiga!
REM better use AGA and the fastest cpu mode you can!
SCREEN 1, 640, 512, 3, AS_MODE_HIRES OR AS_MODE_LACE, "Design Demo 2"
WINDOW 1, "Design Demo 2", (0,0) - (640, 512), AW_FLAG_BACKDROP OR AW_FLAG_BORDERLESS OR AW_FLAG_ACTIVATE, 1

RANDOMIZE Fix(Timer()) * 1000

CONST AS INTEGER w = 20 : REM width
CONST AS INTEGER h = 15: REM height
CONST AS INTEGER sy = 30 : REM cell width
CONST AS integer sx = 30 : REM cell height
CONST AS integer d = 8 : REM distance to border

REM set the colors
palette 0, 0.2, 0.2, 0.2
FOR i AS integer = 1 TO 7
    DIM AS single j=i
    j = j / 13
    palette i, 1-j, 0.8-j/2, j/2     
NEXT


SUB generatedesign
    DIM AS integer x, y, c, t
    DIM AS string stop = ""
    
    LINE (d,d) - (d+w*sx, d+h*sy), 0, BF  
    LOCATE 60, 2
    PRINT "Press any key to interrupt the loops ...   "   
    
    FOR y = 0 TO h-1 
        FOR x = 0 TO w-1
            c = rnd() * 7 + 1: REM take a color palette entry
            t = rnd() * 4: REM select an orientation
            SELECT CASE t
            CASE 0 : REM ellipse
                CIRCLE (x*sx+sx/2+d, y*sy+sy/2+d), sy/5, c , 0,360 , 0.5
                PAINT (x*sx+sx/2+d, y*sy+sy/2+d) , c , c
            CASE 1 : REM another ellipse
                CIRCLE (x*sx+sx/2+d, y*sy+sy/2+d), sy/2.5, c , 0,360 , 2
                PAINT (x*sx+sx/2+d, y*sy+sy/2+d) , c , c
            CASE 2 : REM circle
                CIRCLE (x*sx+sx/2+d, y*sy+sy/2+d), sy/3, c , 0,360 , 1
                PAINT (x*sx+sx/2+d, y*sy+sy/2+d) , c , c
            CASE 3 : REM smaller circle
                CIRCLE (x*sx+sx/2+d, y*sy+sy/2+d), sy/4, c , 0,360 , 1
                PAINT (x*sx+sx/2+d, y*sy+sy/2+d) , c , c
            END SELECT
            
            sleep FOR 0.02:REM for inkey$
            stop = inkey$
            IF stop <> "" THEN
                EXIT FOR
            ENDIF 
        NEXT
        IF stop <> "" THEN
            EXIT FOR
        ENDIF
    NEXT
    LOCATE 60, 2
    PRINT "Press 'Q' to quit or 'N' for a new design!"
END SUB

generatedesign

DIM AS STRING key = inkey$

WHILE TRUE
    key = INKEY$
    SELECT CASE key 
    CASE "q", "Q", "x", "X", chr$(27)
        system
    CASE "n", "N", "d", "D"
        generatedesign
    END SELECT
    
    sleep
WEND
