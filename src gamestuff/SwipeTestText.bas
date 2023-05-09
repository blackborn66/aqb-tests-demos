'
' just a test for swipe recognition
'
' by blackborn66
' https://github.com/blackborn66/aqb-tests-demos
'
OPTION EXPLICIT

DIM SHARED AS INTEGER phit = -1
DIM SHARED AS integer x0, x1, y0, y1, dx, dy
DIM SHARED AS single t0, t1, dt
DIM SHARED AS BYTE direction

CONST AS BYTE DIR_NONE  = 0
CONST AS BYTE DIR_LEFT  = 1
CONST AS BYTE DIR_RIGHT = 2
CONST AS BYTE DIR_UP    = 3
CONST AS BYTE DIR_DOWN  = 4
CONST AS BYTE DIR_NONE_SHORT = 5
CONST AS BYTE DIR_NONE_LONG  = 6

REM * 12: text width
REM * 13: text height   
DIM SHARED AS INTEGER MIN_DISTANCE_X = 6
DIM SHARED AS INTEGER MIN_DISTANCE_Y = 6
DIM SHARED AS INTEGER MAX_SWIPE_TIME = 0.66 ' seconds

FUNCTION dirToString(dir AS BYTE) AS STRING
    SELECT CASE dir
    CASE DIR_NONE
        RETURN "no direction"
    CASE DIR_NONE_SHORT
        RETURN "swipe to short"
    CASE DIR_NONE_LONG
        RETURN "swipe time to long"
    CASE DIR_LEFT
        RETURN "left"
    CASE DIR_RIGHT
        RETURN "right"
    CASE DIR_UP
        RETURN "up"
    CASE DIR_DOWN
        RETURN "down"
    CASE ELSE
        RETURN "unknown direction"
    END SELECT
END FUNCTION

SUB mousecb (BYVAL wid AS INTEGER, BYVAL button AS BOOLEAN, BYVAL mx AS INTEGER, BYVAL my AS INTEGER, BYVAL ud AS ANY PTR)
    DIM AS integer m0 = mouse(0)
    
    ' TRACE m0, button
    IF m0 < 0 THEN
        
        x0 = mx ' start for swipe
        y0 = my ' start for swipe
        t0 = timer()        
        phit = 1        
        ' TRACE "HIT:"; phit; ",mx="; mx; ", my="; my
    ELSE
        
        IF phit >= 0 THEN
            x1 = mx            
            y1 = my
            t1 = timer()        
            dx = x1-x0
            dy = y1-y0
            dt = t1-t0
            
            IF (abs(dx) < MIN_DISTANCE_X) AND (abs(dy) < MIN_DISTANCE_Y) THEN
                direction = DIR_NONE_SHORT
            ELSEIF dt > MAX_SWIPE_TIME THEN
                direction = DIR_NONE_LONG
            ELSEIF (abs(dx) > abs(dy)) THEN
                IF (dx < 0) THEN
                    direction = DIR_LEFT
                ELSE
                    direction = DIR_RIGHT
                END IF                    
            ELSE
                IF (dy > 0) THEN
                    direction = DIR_DOWN
                ELSE
                    direction = DIR_UP
                END IF             
            END IF                
            
            ' TRACE dirToString(direction); x0; x1; dx; y0; y1; dy
            phit = -1            
        END IF
        
    END IF
END SUB

SUB windowcb (BYVAL wid AS INTEGER, BYVAL ud AS ANY PTR)
    SYSTEM
END SUB

WINDOW 1, "Swipe Test"
MIN_DISTANCE_X = Window(12)
MIN_DISTANCE_Y = Window(13) ' one character

ON MOUSE CALL mousecb
MOUSE ON

ON WINDOW CLOSE CALL 1, windowcb

' all sizes in characters
CONST AS integer sizex = 6 ' one field
CONST AS integer sizey = 2
CONST AS integer borderx = 7
CONST AS integer bordery = 3

' size of the board
CONST AS integer width = 9
CONST AS integer height = 6

DIM SHARED AS integer board(width, height)
DIM AS BYTE x, y
DIM AS INTEGER temp

SUB swapAndDrawTiles(x0 AS BYTE, y0 AS BYTE, BYVAL x1 AS BYTE,BYVAL y1 AS BYTE)
    DIM AS INTEGER temp    
    ' swap
    temp = board(x0,y0) 
    board(x0,y0) = board(x1,y1)         
    board(x1,y1) = temp
    ' and draw
    locate y0 * sizey + bordery - 1, x0 * sizex + borderx - 1 : PRINT board(x0,y0)        
    locate y1 * sizey + bordery - 1, x1 * sizex + borderx - 1 : PRINT board(x1,y1)        
END SUB

FOR x = 1 TO width
    FOR y = 1 TO height
        REM board(x,y) = 10000 + x * 100 + y
        board(x,y) = x * 100 + y ' set some number to show the original place  
        locate y * sizey + bordery - 1, x * sizex + borderx - 1 : PRINT board(x,y)        
    NEXT y
NEXT x

LOCATE height * sizey + bordery + 2, borderx + sizex
PRINT "Swipe and Click! Close Window to quit ..."

WHILE INKEY$ = ""
    IF direction <> DIR_NONE THEN
        x = int(int(x0 / Window(12) + borderx) / sizex) -2
        y = int(int(y0 / WIndow(13) + bordery) / sizey) -2  
        TRACE x0;" "; y0;" "; x; " "; y; " "; dirToString(direction)
        IF direction = DIR_RIGHT AND x > 0 AND x < width AND y > 0 AND y <= height THEN
            swapAndDrawTiles x, y, x+1, y
        ELSEIF direction = DIR_LEFT AND x > 1 AND x <= width AND y > 0 AND y <= height THEN
            swapAndDrawTiles x, y, x-1, y
        ELSEIF direction = DIR_DOWN AND x > 0 AND x <= width AND y > 0 AND y < height THEN
            swapAndDrawTiles x, y, x, y+1
        ELSEIF direction = DIR_UP AND x > 0 AND x <= width AND y > 1 AND y <= height THEN
            swapAndDrawTiles x, y, x, y-1
        END IF
        direction = DIR_NONE  
    END IF        
    
    SLEEP
WEND
