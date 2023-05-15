'
' demo for color font creation
' draw colored text on any gfx position
'
' by blackborn66
' https://github.com/blackborn66/aqb-tests-demos
'

OPTION EXPLICIT

SUB windowCB (BYVAL wid AS INTEGER, BYVAL ud AS ANY PTR)
    SYSTEM
END SUB

DIM SHARED AS BITMAP_t PTR fontBitmap

FUNCTION colorPrint(x AS Integer, y AS Integer, t AS String, trans AS Boolean) AS Boolean
    DIM minterm AS byte = &HC0
    IF trans = True THEN 
        minterm = &HE0
    END IF
    FOR p AS Integer = 1 TO LEN(t)
        DIM c AS String = MID$(t, p, 1)
        DIM a AS Integer = ASC(c)
        IF a < 32 OR a > (7 * 32 + 31) THEN
            a = 32
        END IF
        
        DIM px AS Integer = (a MOD 32) * 8 
        DIM py AS Integer = (a / 32 - 1) * 8
        
        REM TRACE c; a; px; py
        PUT (x + (p - 1) * 8, y), fontBitmap, minterm, (px, py) - (px + 7, py + 7)
    NEXT p 
    
    RETURN true
END FUNCTION

SUB createFont
    
    ' swap the palette entries 0 and 1
    PALETTE 0, 0, 0, 0
    PALETTE 1, 255/170, 255/170, 255/170
    
    ' create a color scale with 8 entries
    FOR c AS single = 0 TO 7
        DIM AS single r = 1 - c / 14
        DIM AS single g = 1 - c / 10
        DIM AS single B = 0.4
        palette 31 - c, r, g, B
    NEXT c 
    
    ' use all bits for the text mask
    ' zero bits for background
    COLOR 31, 0, 2, DRMD_JAM2
    
    locate 2, 1 
    PRINT "character table:"
    
    ' print all needed letters on screen
    locate 3, 1
    DIM fontString AS STRING = ""
    FOR j AS INTEGER = 1 TO 7
        fontString = ""        
        FOR i AS INTEGER = 0 TO 31 
            fontString = fontString + chr$(j*32 + i)
        NEXT i
        PRINT fontString
    NEXT j        
    
    fontBitmap = BITMAP (32 * 8, 7 * 8, 5)
    ' get mask
    GET (0, 3 * 8 + 1) - (32 * 8 - 1, (3 + 7) * 8), fontBitmap
    
    ' draw lines as font texture
    FOR l AS INTEGER = 3 * 8 + 1 TO (3 + 7) * 8
        LINE (0, l) - (32 * 8 - 1, l), 31 - (l - 1) MOD 8 ' a color scale
    NEXT l
    
    ' stencil
    put (0, 3 * 8 + 1), fontBitmap, &H80
    
    ' save
    GET (0, 3 * 8 + 1) - (32 * 8 - 1, (3 + 7) * 8), fontBitmap
END SUB

' ---- main -----

' old school game screen size with 32 colors
SCREEN 1, 320, 200, 5, 0, "Colored Font Demo"
WINDOW 1, "",(0,0)-(320, 200) , AW_FLAG_SIMPLE_REFRESH OR AW_FLAG_BORDERLESS OR AW_FLAG_ACTIVATE OR AW_FLAG_REPORTMOUSE, 1

createFont

' show all colors 
FOR c AS Integer = 0 TO 31
    LINE (c * 10, 0) - (c * 10 + 10, 10), c, BF
NEXT c

' draw a background grid
FOR x AS Integer = 0 TO 300 STEP 7
    LINE (x, 100) - (x + 99, 199), 8
    LINE (x + 99, 100) - (x, 199), 8
NEXT x

' test the font
colorPrint(  0, 110, "This is a test! §$&/\()[]{} ²³ é É âÂ *", True)
colorPrint(  0, 120, "This", False)
colorPrint( 33, 121, "This", False)
colorPrint( 66, 123, "This", False)
colorPrint( 99, 126, "This is a test! ß ;:@", True)
colorPrint(100, 134, "This is a test! ÄÖÜ #", True)
colorPrint(101, 142, "This is a test! äöü *", False)

ON WINDOW CLOSE CALL 1, windowCB

LOCATE 21, 1
COLOR 9
PRINT "Press any key to quit!         "
WHILE inkey$ = ""
    sleep
WEND
