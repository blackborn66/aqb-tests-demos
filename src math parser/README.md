# AQB Mathematical Expression Parser
 
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

###How to use the 
'''
DIM AS STRING expr = "1/4 * sin(x) + 2"
DIM AS STRING fstr = FormatString(expr)
DIM AS STRING crpn = ConvertToRPN(fstr)
DIM AS SINGLE x = 2
DIM AS SINGLE y = 0
DIM AS SINGLE z = 0
DIM AS SINGLE result = Calculate(crpn, x, y, z)
'''
after each step look at the global variable exception
there you can see if it's a problem wiht the expression / or in the code ;)

TODO:
 * change to OOP
 * maybe use it as lib or module
