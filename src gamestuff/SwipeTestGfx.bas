'
' swipe some tiles in match three style
' tiles are procedural generated
'
' by blackborn66
' https://github.com/blackborn66/aqb-tests-demos
'

OPTION EXPLICIT

' all sizes in pixels
CONST AS INTEGER TILE_WIDTH  = 16 REM use 32 for HIRES MODES
CONST AS INTEGER TILE_HEIGHT = 16
CONST AS INTEGER BORDER_X = 10
CONST AS INTEGER BORDER_Y = 40

' size of the board in tiles
CONST AS BYTE BOARD_WIDTH  = 8
CONST AS BYTE BOARD_HEIGHT = 8

' colors and tiles
CONST AS BYTE MAX_NUM_TILES  = 8 ' number of different standard tiles
CONST AS BYTE NUM_COLORS_PER_TILE = 3 ' each tile gets 3 own colors
CONST AS BYTE NUM_COLORS = MAX_NUM_TILES * NUM_COLORS_PER_TILE ' each tile gets 3 own colors
' first 8 colors are reserved!
CONST AS BYTE START_COLOR_FOR_TILES = 8
' all other colors are generated for the tiles
DIM SHARED AS SINGLE tileColors(NUM_COLORS, 3) ' rgb for each
DIM SHARED AS BITMAP_t PTR tiles(MAX_NUM_TILES)

' swipe stuff
DIM SHARED AS BYTE phit = -1 ' swipe on?
DIM SHARED AS INTEGER x0, x1, y0, y1, dx, dy ' swipe mouse coordinates
DIM SHARED AS SINGLE t0, t1, dt ' swipe timing
DIM SHARED AS BYTE direction ' swipe

' recognized swipe directions
CONST AS BYTE DIR_NONE  = 0
CONST AS BYTE DIR_LEFT  = 1
CONST AS BYTE DIR_RIGHT = 2
CONST AS BYTE DIR_UP    = 3
CONST AS BYTE DIR_DOWN  = 4
CONST AS BYTE DIR_NONE_SHORT = 5
CONST AS BYTE DIR_NONE_LONG  = 6

' swipe constants
DIM SHARED AS INTEGER MIN_DISTANCE_X = TILE_WIDTH  / 2
DIM SHARED AS INTEGER MIN_DISTANCE_Y = TILE_HEIGHT / 2
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

' swipe tracking
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

SUB setupColorsAndTiles
    DIM AS SINGLE r, g, B, rt, gt, bt
    
    LOCATE 2, 1 
    PRINT "setup colors and tiles ..."
    
    FOR c AS BYTE = 1 TO MAX_NUM_TILES
        ' color constants for the brightest level
        SELECT CASE c
        CASE 1 
            r = 0.9
            g = 0.3
            B = 0.4
        CASE 2
            r = 0.2
            g = 0.8
            B = 0.1
        CASE 3 
            r = 0.3
            g = 0.3
            B = 0.9
        CASE 4 
            r = 0.9
            g = 0.9
            B = 0.2
        CASE 5 
            r = 0.9
            g = 0.7
            B = 0.5
        CASE 6 
            r = 0.5
            g = 0.9
            B = 0.6
        CASE 7 
            r = 0.9
            g = 0.5
            B = 0.7
        CASE 8 
            r = 0.6
            g = 0.6
            B = 0.9
        END SELECT
        
        ' two darker levels are generated
        FOR tileColor AS BYTE = 1 TO NUM_COLORS_PER_TILE
            rt = r - r / NUM_COLORS_PER_TILE / 2 * (tileColor-1)
            gt = g - g / NUM_COLORS_PER_TILE / 2 * (tileColor-1)
            bt = B - B / NUM_COLORS_PER_TILE / 2 * (tileColor-1)
            DIM AS BYTE palNumber = START_COLOR_FOR_TILES + (c-1) * NUM_COLORS_PER_TILE + (tileColor - 1)
            ' TRACE palNumber, rt, gt, bt            
            PALETTE palNumber, rt, gt, bt
            LINE (10 + (c-1) * TILE_WIDTH, 30 + (tileColor-1) * TILE_HEIGHT) - (10 + c * TILE_WIDTH, 30 + tileColor * TILE_HEIGHT), palNumber, BF
        NEXT tileColor
        
        ' draw background pattern for one tile
        FOR l AS BYTE = 0 TO TILE_WIDTH + TILE_HEIGHT
            DIM AS BYTE palNumber = l MOD (NUM_COLORS_PER_TILE * 2)
            IF palNumber > (NUM_COLORS_PER_TILE-1) THEN
                palNumber = NUM_COLORS_PER_TILE - (palNumber - NUM_COLORS_PER_TILE) - 1
            END IF                
            palNumber = palNumber + START_COLOR_FOR_TILES + (c-1) * NUM_COLORS_PER_TILE
            LINE (10 + (c-1) * TILE_WIDTH, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + l) - (10 + (c) * TILE_WIDTH -1, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + TILE_WIDTH + l -1), palNumber
        NEXT l
        
        ' draw a border around it
        DIM AS BYTE palNumber = START_COLOR_FOR_TILES + (c-1) * NUM_COLORS_PER_TILE
        LINE (10 + (c-1) * TILE_WIDTH, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + TILE_WIDTH) - (10 + (c) * TILE_WIDTH -1, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + TILE_HEIGHT + TILE_WIDTH -1), palNumber, B
        LINE (10 + (c-1) * TILE_WIDTH +1, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + TILE_WIDTH +1) - (10 + (c) * TILE_WIDTH -1, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + TILE_HEIGHT + TILE_WIDTH -1), palNumber+2, B
        LINE (10 + (c-1) * TILE_WIDTH +1, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + TILE_WIDTH +1) - (10 + (c) * TILE_WIDTH -2, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + TILE_HEIGHT + TILE_WIDTH -2), palNumber+1, B
        ' beautify the corners
        PSET (10 + (c  ) * TILE_WIDTH -1, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + TILE_WIDTH), palNumber+1
        PSET (10 + (c-1) * TILE_WIDTH, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + TILE_HEIGHT + TILE_WIDTH -1), palNumber+1
        
        ' take the tile image
        IF c < 10 THEN
            tiles(c) = BITMAP (TILE_WIDTH, TILE_HEIGHT, 5)
            GET (10 + (c-1) * TILE_WIDTH, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + TILE_WIDTH) - (10 + (c) * TILE_WIDTH -1, 30 + NUM_COLORS_PER_TILE * TILE_HEIGHT + TILE_HEIGHT + TILE_WIDTH -1), tiles(c)
            ' PUT (0, 0), tiles(c)
        END IF
        
    NEXT c
END SUB

' board stuff
DIM SHARED AS integer board(BOARD_WIDTH, BOARD_HEIGHT)

SUB swapAndDrawTiles(x0 AS INTEGER, y0 AS INTEGER, BYVAL x1 AS INTEGER,BYVAL y1 AS INTEGER)
    DIM AS BYTE temp
    ' FALSE = no animation
    CONST AS BOOLEAN ANIMATE_SWAP = TRUE
    ' swap
    temp = board(x0,y0) 
    board(x0,y0) = board(x1,y1)         
    board(x1,y1) = temp
    ' and draw   
    IF ANIMATE_SWAP THEN
        ' the step value changes the speed of the animation
        FOR a AS BYTE = 0 TO TILE_HEIGHT + TILE_WIDTH STEP 4
            DIM AS SINGLE hw = (TILE_HEIGHT + TILE_WIDTH)
            DIM AS SINGLE deltaX = (((BORDER_X + (x0-1) * TILE_WIDTH)  - (BORDER_X + (x1-1) * TILE_WIDTH )) / hw) * a
            DIM AS SINGLE deltaY = (((BORDER_Y + (y0-1) * TILE_HEIGHT) - (BORDER_Y + (y1-1) * TILE_HEIGHT)) / hw) * a
            
            ' TRACE a, deltaX, deltaY
            VWAIT
            ' clean the space by drawing in background color
            LINE (BORDER_X + (x0-1) * TILE_WIDTH, BORDER_Y + (y0-1) * TILE_HEIGHT) - (BORDER_X + x0 * TILE_WIDTH -1, BORDER_Y + y0 * TILE_HEIGHT -1), 0, BF
            LINE (BORDER_X + (x1-1) * TILE_WIDTH, BORDER_Y + (y1-1) * TILE_HEIGHT) - (BORDER_X + x1 * TILE_WIDTH -1, BORDER_Y + y1 * TILE_HEIGHT -1), 0, BF
            ' show the moving tiles
            PUT (BORDER_X + (x0-1) * TILE_WIDTH - deltaX, BORDER_Y + (y0-1) * TILE_HEIGHT - deltaY), tiles(board(x1,y1))
            PUT (BORDER_X + (x1-1) * TILE_WIDTH + deltaX, BORDER_Y + (y1-1) * TILE_HEIGHT + deltaY), tiles(board(x0,y0))
        NEXT a
    ELSE
        PUT (BORDER_X + (x0-1) * TILE_WIDTH, BORDER_Y + (y0-1) * TILE_HEIGHT), tiles(board(x0,y0))
        PUT (BORDER_X + (x1-1) * TILE_WIDTH, BORDER_Y + (y1-1) * TILE_HEIGHT), tiles(board(x1,y1))
    END IF
END SUB

SUB setupAndShowBoard
    RANDOMIZE timer()
    ' setup and draw the board
    FOR x AS BYTE = 1 TO BOARD_WIDTH
        FOR y AS BYTE = 1 TO BOARD_HEIGHT
            board(x,y) = INT(RND() * 8) + 1
            PUT (BORDER_X + (x-1) * TILE_WIDTH, BORDER_Y + (y-1) * TILE_HEIGHT), tiles(board(x,y))
        NEXT y
    NEXT x
END SUB

' ----- MAIN ---------------------------------

' old school game screen size with 32 colors
SCREEN 1, 320, 200, 5, 0, "Swipe Test Gfx"
WINDOW 1, "Swipe Test Gfx",(0,0)-(320, 200) , AW_FLAG_SIMPLE_REFRESH OR AW_FLAG_BORDERLESS OR AW_FLAG_ACTIVATE OR AW_FLAG_REPORTMOUSE, 1

ON MOUSE CALL mousecb
MOUSE ON

ON WINDOW CLOSE CALL 1, windowcb

setupColorsAndTiles

LOCATE 17, 1
PRINT "Press any key to continue!"
WHILE inkey$ = ""
    sleep
WEND

CLS
LOCATE 1, 1
PRINT "Swipe and Click!"
PRINT "Any key to quit"

setupAndShowBoard

DIM AS INTEGER x, y

' main loop
WHILE INKEY$ = ""
    IF (direction <> DIR_NONE) AND (x0 >= BORDER_X) AND (y0 >= BORDER_Y) THEN
        ' calculate swipe start coordinates in board tile numbers
        x = (x0 - BORDER_X) / TILE_WIDTH  +1
        y = (y0 - BORDER_Y) / TILE_HEIGHT +1
        
        TRACE x0; y0; x; y; " "; dirToString(direction)
        ' swap tiles if swipe was in allowed region
        IF direction = DIR_RIGHT AND x > 0 AND x < BOARD_WIDTH AND y > 0 AND y <= BOARD_HEIGHT THEN
            swapAndDrawTiles x, y, x+1, y
        ELSEIF direction = DIR_LEFT AND x > 1 AND x <= BOARD_WIDTH AND y > 0 AND y <= BOARD_HEIGHT THEN
            swapAndDrawTiles x, y, x-1, y
        ELSEIF direction = DIR_DOWN AND x > 0 AND x <= BOARD_WIDTH AND y > 0 AND y < BOARD_HEIGHT THEN
            swapAndDrawTiles x, y, x, y+1
        ELSEIF direction = DIR_UP AND x > 0 AND x <= BOARD_WIDTH AND y > 1 AND y <= BOARD_HEIGHT THEN
            swapAndDrawTiles x, y, x, y-1
        END IF
        direction = DIR_NONE  
    END IF        
    
    SLEEP
WEND
