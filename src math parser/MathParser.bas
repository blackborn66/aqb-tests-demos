'
' AQB Mathematical Expression Parser
' 
' based on a C# implementation by Yerzhan Kalzhani
' https://github.com/kirnbas/MathParserTK
' https://www.codeproject.com/Tips/381509/Math-Parser-NET-Csharp
'
' AQB port by blackborn66
' https://github.com/blackborn66/aqb-tests-demos
'
' I changed some functions
' and added support for variables
'
' supported functions
'   sin, cos, tan, atn, @log2, log10, ln, exp, abs
' supported variables 
'   x, y, z
' supported constants
'   e, pi
' supported operators
'   + - * / ^
' decimal separator is a point like in 3.14
' 
' NO implicit multiplication!
' for f(x) = 3x^2 use "3*x^2"
' 
' How to use the parser
' ---------------------
'
' DIM AS STRING expr = "1/4 * sin(x) + 2"
' DIM AS STRING fstr = FormatString(expr)
' DIM AS STRING crpn = ConvertToRPN(fstr)
' DIM AS SINGLE x = 2
' DIM AS SINGLE y = 0
' DIM AS SINGLE z = 0
' DIM AS SINGLE result = Calculate(crpn, x, y, z)
'
' after each step look at the global variable exception
' there you can see if it's a problem with the expression / or in the code ;)
'

'------------------------ MathParser ------------------------------------

DIM SHARED exception AS string = "" : REM hold a message about a problem
DIM SHARED WHITE_SPACES AS string = " "
DIM SHARED NumberMarker AS string = "#"
DIM SHARED OperatorMarker AS string = "$"
DIM SHARED FunctionMarker AS string = "@"
DIM SHARED decimalSeperator AS string = "."
DIM SHARED supportedLetters AS string = "abcdefghijklmnopqrstuvwxyz"
DIM SHARED supportedDigits AS string = "0123456789"
DIM SHARED supportedOperators AS string = "+-*/^()"
DIM SHARED unsupportedChars AS string = "#$@,"

DIM SHARED stack(100) AS string
DIM SHARED stackCount AS integer
DIM SHARED varX AS single = 0
DIM SHARED varY AS single = 0
DIM SHARED varZ AS single = 0

FUNCTION FormatString(BYVAL expression AS string) AS string
    
    IF expression = "" THEN
        exception = "Expression is empty"
        RETURN ""
    END IF
    
    DIM formattedString AS string = ""
    DIM numberOfParenthesis AS integer = 0
    
    expression = lcase$(expression)
    FOR i AS integer = 1 TO LEN(expression)
        DIM c AS string = ""
        
        c = mid$(expression, i, 1)
        
        IF c = "(" THEN
            numberOfParenthesis = numberOfParenthesis + 1
            formattedString = formattedString + c
        ELSEIF c = ")" THEN
            numberOfParenthesis = numberOfParenthesis - 1
            formattedString = formattedString + c
            ' ELSEIF c = "x" THEN
            '    formattedString = formattedString + "x()"
        ELSEIF instr(,WHITE_SPACES,c) > 0 THEN
            CONTINUE
        ELSE
            formattedString = formattedString + c
        END IF
    NEXT i
    
    IF numberOfParenthesis <> 0 THEN
        exception = "Number of left and right parenthesis is not equal"
        RETURN ""
    END IF
    RETURN formattedString
END FUNCTION

FUNCTION GetPriority(token AS string) AS byte
    
    SELECT CASE token
    CASE "$("
        RETURN 0
    CASE "$+", "$-"
        RETURN 2
    CASE "$*", "$/"
        RETURN 4
    CASE "$un+", "$un-"
        RETURN 6
    CASE "$^", "@sqr"
        RETURN 8
    CASE "@sin", "@cos", "@tan", "@atn", "@log2", "@log10", "@ln", "@exp", "@abs", "@x", "@y", "@z" 
        RETURN 10
    END SELECT
    
    exception = "Unknown operator in GetPriority: " + token
    RETURN 0
END FUNCTION

FUNCTION IsRightAssociated(token AS string) AS Boolean
    RETURN token = (OperatorMarker + "^")
END FUNCTION

FUNCTION Priority(token1 AS string, token2 AS string) AS Boolean
    IF IsRightAssociated(token1) THEN
        RETURN GetPriority(token1) < GetPriority(token2)
    END IF 
    ' ELSE
    RETURN GetPriority(token1) <= GetPriority(token2)
END FUNCTION

FUNCTION GetFunctionToken(token AS string) AS string
    SELECT CASE token
    CASE "sin", "cos", "tan", "atn", "log10", "log2", "ln", "exp": ', "abs", "x", "y", "z"
        RETURN FunctionMarker + token
    END SELECT
    
    exception = "unknown function (GFT): " + token
    RETURN ""
END FUNCTION

FUNCTION GetConstantToken(token AS string) AS string
    SELECT CASE token
    CASE "e"
        RETURN NumberMarker + STR$(2.718281828459045)
    CASE "pi"
        RETURN NumberMarker + STR$(3.141592653589793)
    END SELECT
    
    exception = "unknown constant: " + token
    RETURN ""
END FUNCTION

FUNCTION GetVariableToken(token AS string) AS string
    SELECT CASE token
    CASE "x", "y", "z"
        RETURN FunctionMarker + token
    END SELECT
    
    exception = "unknown variable: " + token
    RETURN ""
END FUNCTION

FUNCTION LexicalAnalysisInfixNotation(expression AS string, pos AS INTEGER) AS string
    DIM c AS string = ""
    
    REM TRACE expression, pos    
    
    ' Receive first char
    DIM token AS string = mid$(expression, pos, 1)
    
    ' If it is an operator
    IF instr(, supportedOperators, token) > 0 THEN
        pos = pos + 1
        ' Determine it is unary or binary operator
        ' IF pos = 2 OR mid$(expression, pos - 2, 1) = "(" OR instr(, supportedOperators, mid$(expression, pos - 2, 1)) > 0 THEN
        IF pos = 2 OR instr(, "(+-*/^", mid$(expression, pos - 2, 1)) > 0 THEN
            IF token = "+" THEN
                RETURN OperatorMarker + "un+"
            ELSEIF token = "-" THEN
                RETURN OperatorMarker + "un-"
            END IF
        END IF
        RETURN OperatorMarker + token
    ELSEIF instr(, unsupportedChars, token) > 0 THEN
        exception = "Unsupported character found: " + token + " / " + STR$(pos)
        RETURN ""
    ELSEIF instr(, supportedLetters, token) THEN
        pos = pos + 1
        WHILE instr(, supportedLetters+supportedDigits, mid$(expression, pos, 1)) > 0 AND pos < LEN(expression)
            token = token + mid$(expression, pos, 1)
            PRINT "token (LAIN):", token, pos, LEN(token)
            pos = pos + 1
        WEND
        
        IF GetFunctionToken(token) <> "" THEN
            RETURN GetFunctionToken(token)
        ELSEIF GetConstantToken(token) <> "" THEN
            exception = ""
            RETURN GetConstantToken(token)
        ELSEIF GetVariableToken(token) <> "" THEN
            exception = ""
            RETURN GetVariableToken(token)
        ELSE
            exception = "Unknown token (LAIN):" + token
        END IF
    ELSEIF instr(, supportedDigits, token) > 0 THEN
        pos = pos + 1
        ' Read the whole part of number
        WHILE instr(, supportedDigits+decimalSeperator, mid$(expression, pos, 1)) > 0 AND pos <= LEN(expression)
            token = token + mid$(expression, pos, 1)
            pos = pos + 1
        WEND
        
        ' RETURN NumberMarker + STR$(val(token))
        RETURN NumberMarker + token
    ELSE
        exception = "Unknown token in expression: '" + token + "' (" + STR$(LEN(token)) + ")"
    END IF
END FUNCTION

FUNCTION SyntaxAnalysisInfixNotation(token AS string, outputString AS string) AS string
    DIM marker AS string = left$(token, 1)
    
    IF marker = NumberMarker THEN
        outputString = outputString + token
    ELSEIF marker = FunctionMarker THEN
        ' TRACE "Push function: " + token
        stackCount = stackCount + 1
        stack(stackCount) = token
    ELSEIF token = "$(" THEN
        ' TRACE "Push function: " + token
        stackCount = stackCount + 1
        stack(stackCount) = token
    ELSEIF token = "$)" THEN
        ' pop elements from stack to output string 
        
        DIM elem AS string = ""
        WHILE elem <> "$("
            outputString = outputString + elem
            elem = stack(stackCount) : ' pop
            stackCount = stackCount - 1
        WEND
        
        ' if after this a function is in the peek of stack then put it to string
        IF stackCount > 0 THEN 
            IF left$(stack(stackCount), 1) = FunctionMarker THEN
                outputString = outputString + stack(stackCount) : ' pop
                stackCount = stackCount - 1
            END IF
        END IF
    ELSE
        
        DO
            IF stackCount < 1 THEN
                EXIT DO
            END IF
            IF NOT Priority(token, stack(stackCount)) THEN   
                EXIT DO
            END IF
            
            outputString = outputString + stack(stackCount) : ' pop
            stackCount = stackCount - 1
        LOOP
        
        ' TRACE "Push operator: " + token
        stackCount = stackCount + 1
        stack(stackCount) = token      
        
    END IF
    
    ' TRACE "SAIN", token, outputString
    RETURN outputString : ' ???
END FUNCTION

FUNCTION ConvertToRPN(BYVAL expression AS string) AS string
    DIM pos AS integer = 1: REM Current position of lexical analysis
    DIM outputString AS string = ""
    REM DIM stack(100) AS string
    REM DIM stackCount AS integer
    stackCount = 0: ' reset stack
    
    ' workaround for the problem with a variable on the right side in string
    expression = "(" + expression + ")"
    PRINT "convert ", expression
    
    WHILE pos <= LEN(expression)
        DIM token AS string = LexicalAnalysisInfixNotation(expression, pos)
        IF exception <> "" THEN : RETURN "" 
        END IF
        PRINT "Token: ", token, pos, exception
        REM outputString = SyntaxAnalysisInfixNotation(token, outputString)
        SyntaxAnalysisInfixNotation(token, outputString)
        PRINT "outputString: ", outputString, stackCount, stack(stackCount)
        IF exception <> "" THEN : RETURN "" 
        END IF
    WEND
    
    REM Pop all elements from stack to output string            
    WHILE stackCount > 0
        REM There should be only operators
        IF (left$(stack(stackCount), 1) = OperatorMarker) THEN
            outputString = outputString + stack(stackCount)
            stackCount = stackCount - 1
        ELSE
            exception = "Format exception, there is a function without parenthesis"
            EXIT WHILE            
        END IF
    WEND
    
    RETURN outputString
END FUNCTION

FUNCTION LexicalAnalysisRPN(expression AS string, pos AS integer) AS string
    DIM token AS string = mid$(expression, pos, 1)
    
    WHILE pos < LEN(expression)
        pos = pos + 1
        DIM c AS string = mid$(expression, pos, 1)
        IF c = NumberMarker OR c = OperatorMarker OR c = FunctionMarker THEN
            EXIT WHILE
        END IF
        
        token = token + c
    WEND
    
    RETURN token
END FUNCTION

FUNCTION NumberOfArguments(token AS string) AS byte
    SELECT CASE token
    CASE "@x", "@y", "@z"
        RETURN 0
    CASE "$un+", "$un-", "@sqr", "@sin", "@cos", "@tan", "@atn", "@ln", "@exp", "@abs", "@log2", "@log10"
        RETURN 1
    CASE "$+", "$-",  "$*", "$/", "$^"
        RETURN 2
    END SELECT        
    
    exception = "(NoA)Unknown operator: " + token
    RETURN 0
END FUNCTION

FUNCTION SyntaxAnalysisRPN(token AS string) AS Boolean
    DIM rst AS single = 0.0
    
    DIM c0 AS string = left$(token, 1)
    DIM arg1 AS single = 0.0
    DIM arg2 AS single = 0.0
    
    ' TRACE "Calc - token:", token
    ' TRACE "Calc - numoa:", NumberOfArguments(token)
    ' TRACE "stack size:", stackCount
    
    IF c0 = NumberMarker THEN
        stackCount = stackCount + 1
        stack(stackCount) = right$(token, LEN(token) - 1)
        ' TRACE "put number to stack: ", stackCount, stack(stackCount)
    ELSEIF  NumberOfArguments(token) = 0 THEN
        IF token = "@x" THEN
            stackCount = stackCount + 1
            stack(stackCount) = STR$(varX)
        ELSEIF token = "@y" THEN
            stackCount = stackCount + 1
            stack(stackCount) = STR$(varY)
        ELSEIF token = "@z" THEN
            stackCount = stackCount + 1
            stack(stackCount) = STR$(varZ)
        ELSE
            exception = "Unknown token (SARPN0): " + token
        END IF
    ELSEIF  NumberOfArguments(token) = 1 THEN
        arg1 = val(stack(stackCount))
        stackCount = stackCount - 1
        
        exception = "Unknown token (SARPN): " + token
        SELECT CASE token
        CASE "$un+"
            rst = arg1
            exception = ""
        CASE "$un-"
            rst = -arg1
            exception = ""
        CASE "@sqr"
            rst = sqr(arg1)
            exception = ""
        CASE "@sin"
            rst = sin(arg1)
            exception = ""
        CASE "@cos"
            rst = cos(arg1)
            exception = ""
        CASE "@ln"
            rst = log(arg1)
            exception = ""
        CASE "@log2"
            rst = log(arg1) / log(2)
            exception = ""
        CASE "@log10"
            rst = log(arg1) / log(10)
            exception = ""
        CASE "@abs"
            rst = abs(arg1)
            exception = ""
        CASE "@exp"
            rst = exp(arg1)
            exception = ""
        CASE "@tan"
            rst = tan(arg1)
            exception = ""
        CASE "@atn"
            rst = atn(arg1)
            exception = ""
        END SELECT
        
        stackCount = stackCount + 1
        stack(stackCount) = STR$(rst)
        ' TRACE "put result to stack: ", stackCount, rst, STR$(rst)    
    ELSE
        ' NumberOfArguments(token) = 2
        arg2 = val(stack(stackCount))
        stackCount = stackCount - 1
        arg1 = val(stack(stackCount))
        stackCount = stackCount - 1
        
        exception = "Unknown token (SaRPN): " + token
        ' TRACE "Calculation: ", token, arg1, arg2, stackCount
        SELECT CASE token
        CASE "$+"
            rst = arg1 + arg2
            exception = ""
        CASE "$-"
            rst = -arg1 - arg2
            exception = ""
        CASE "$*"
            rst = arg1 * arg2
            exception = ""
        CASE "$/"
            rst = arg1 / arg2
            exception = ""
        CASE "$^"
            rst = arg1 ^ arg2
            exception = ""        
            ' CASE "@log"
            '    rst = log(arg1) / log(arg2)
            '    exception = ""        
        END SELECT
        
        stackCount = stackCount + 1
        stack(stackCount) = STR$(rst)
        ' TRACE "put result to stack: ", stackCount, rst, STR$(rst)    
    END IF
    
    RETURN true
END FUNCTION

FUNCTION Calculate(expression AS string, x AS single, y AS single, z AS single) AS single
    DIM pos AS integer = 1
    stackCount = 0
    
    varX = x
    varY = y
    varZ = z
    TRACE "exp,len", expression, LEN(expression)
    WHILE pos < LEN(expression)
        DIM AS string token = LexicalAnalysisRPN(expression, pos)
        TRACE "tok,pos", token, pos
        SyntaxAnalysisRPN(token)
    WEND
    
    IF stackCount > 1 THEN
        exception = "Excess operand"
        RETURN 0
    END IF
    
    RETURN val(stack(stackCount))
END FUNCTION

'------------------------ MathParser ------------------------------------



window 1, "Draw Grid", (0,0)-(1280,512), AW_FLAG_SIMPLE_REFRESH OR AW_FLAG_BORDERLESS OR AW_FLAG_ACTIVATE

' Let see what we can do with expressions

cls


DIM AS STRING expr = "1/3 * x + y * z"
DIM AS STRING fstr = FormatString(expr) : PRINT "expression: ", expr, " formatted: ", fstr, " exception: ", exception
DIM AS STRING crpn = ConvertToRPN(fstr) : PRINT "expression: ", expr, " RPN: ", crpn, " exception: ", exception

TRACE "RPN:",crpn, "  exception:", exception

' check the stack - something left?
FOR n AS integer = 1 TO stackCount
    PRINT "stack: ", n, stack(stackCount)
NEXT

DIM AS single s1, s2

FOR v AS single = 0 TO 3 STEP 0.5
    ' Why is s2 wrong calculated?    
    s2 = (1/4 * v + 2 * 3)
    s1 = Calculate(crpn, v, 2, 3) : REM y=2 z=3
    PRINT "Result:", v, s1, s2, "  exception:", exception
NEXT

PRINT
PRINT "Press any key!"

WHILE inkey$ = ""
    sleep
WEND
