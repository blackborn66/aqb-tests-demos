REM
REM create a simple generative design
REM 
REM by blackborn66
REM https://github.com/blackborn66/aqb-tests-demos
REM

OPTION EXPLICIT

REM PAL Amiga!
REM better use AGA and the fastest cpu mode you can!
SCREEN 1, 640, 512, 3, AS_MODE_HIRES OR AS_MODE_LACE, "Design Demo 1"
WINDOW 1, "Design Demo 1", (0,0) - (640, 512), AW_FLAG_BACKDROP OR AW_FLAG_BORDERLESS OR AW_FLAG_ACTIVATE, 1

RANDOMIZE Fix(Timer()) * 1000

CONST AS INTEGER w = 20 : REM width 13
CONST AS INTEGER h = 15 : REM height 14
CONST AS INTEGER sy = 30 : REM cell width
CONST AS integer sx = 30 : REM cell height
CONST AS integer d = 12 : REM distance to border

REM set the colors
palette 0, 0.1, 0.1, 0.1
FOR i AS integer = 1 TO 7
    DIM AS single j = i, red, blue, green
    j = j / 13
    palette i, 1-j, 0.8-j, j     
NEXT

SUB generatedesign
    DIM AS integer x, y, c, t
    CONST AS SINGLE r = 1: REM 0.44
    DIM AS string stop = ""
    
    LINE (d,d) - (d+w*sx, d+h*sy), 0, BF  
    LOCATE 60, 2
    PRINT "Press any key to interrupt the loops ...   "   
    
    FOR y = 0 TO h-1 
        FOR x = 0 TO w-1
            c = rnd() * 7 + 1: REM take a color palette entry
            t = rnd() * 4: REM select an orientation
            SELECT CASE t
            CASE 0
                CIRCLE (x*sx+d, y*sy+d), sy,c , 0,90 , r
                LINE (x*sx+d, y*sy+d) - ((x+1)*sx+d, y*sy+d), c
                LINE (x*sx+d, y*sy+d) - (x*sx+d, (y+1)*sy+d), c
                PAINT (x*sx+d+1, y*sy+d+1) , c , c
            CASE 1
                CIRCLE ((x+1)*sx+d, (y+1)*sy+d), sy,c , 180, 270 , r
                LINE ((x+1)*sx+d, (y+1)*sy+d) - ((x+1)*sx+d, (y)*sy+d), c
                LINE ((x+1)*sx+d, (y+1)*sy+d) - ((x)*sx+d, (y+1)*sy+d), c
                PAINT ((x+1)*sx+d-1, (y+1)*sy+d-1) , c , c
            CASE 2
                CIRCLE ((x+1)*sx+d, y*sy+d), sy,c , 90, 180 , r
                LINE ((x+1)*sx+d, y*sy+d) - (x*sx+d, y*sy+d), c
                LINE ((x+1)*sx+d, y*sy+d) - ((x+1)*sx+d, (y+1)*sy+d), c
                PAINT ((x+1)*sx+d-1, y*sy+d+1), c, c
            CASE 3
                CIRCLE (x*sx+d, (y+1)*sy+d), sy,c , 270,360 , r
                LINE (x*sx+d, (y+1)*sy+d) - (x*sx+d, y*sy+d), c
                LINE (x*sx+d, (y+1)*sy+d) - ((x+1)*sx+d, (y+1)*sy+d), c
                PAINT (x*sx+d+1, (y+1)*sy+d-1), c, c
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
