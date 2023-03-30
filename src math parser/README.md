# AQB Mathematical Expression Parser
 
based on a C# implementation by Yerzhan Kalzhani<br>
https://github.com/kirnbas/MathParserTK<br>
https://www.codeproject.com/Tips/381509/Math-Parser-NET-Csharp<br>
<br>
 AQB port by blackborn66<br>
 https://github.com/blackborn66/aqb-tests-demos<br>
<br>
 I changed some functions<br>
 and added support for variables<br>
<br>
## supported functions
   sin, cos, tan, atn, log2, log10, ln, exp, abs
## supported variables
   x, y, z
## supported constants
   e, pi
## supported operators<br>
`  + - * / ^ `<br>

## Attention!
decimal separator is a point like in 3.14<br>
<br>
NO implicit multiplication!<br>
 for f(x) = 3x^2 use ` "3*x^2" `<br>
 <br>

## How to use the parser

`DIM AS STRING expr = "1/4 * sin(x) + 2"` <br>
`DIM AS STRING fstr = FormatString(expr)`<br>
`DIM AS STRING crpn = ConvertToRPN(fstr)`<br>
`DIM AS SINGLE x = 2`<br>
`DIM AS SINGLE y = 0`<br>
`DIM AS SINGLE z = 0`<br>
`DIM AS SINGLE result = Calculate(crpn, x, y, z)`<br>
<br>
## Attention!
after each step look at the global variable exception<br>
there you can see if it's a problem with the expression / or in the code ;)<br>
<br>
## TODO:
 * change to OOP
 * maybe use it as lib or module
