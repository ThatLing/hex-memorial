CLS

DEFINT A-Z
Address = 889: REM 889 = port address, other addresses could be 633 or 957
PRINT "Press the enter key to read printer port pins (15,13,12,10,11)"
PRINT "A (0) reading indicates the pin is at ground level, (1) indicates"
PRINT "the pin is at a high level or unterminated."

INPUT A$

V = INP(Address)

P11 = 1

IF V > 127 THEN
	P11 = 0
	V = V - 128
	
IF V > 63 THEN
	P10 = 1
	V = V - 64
	
IF V > 31 THEN
	P12 = 1
	V = V - 32
	
IF V > 15 THEN
	P13 = 1
	V = V - 16
	
IF V > 7 THEN
	P15 = 1
	

PRINT
PRINT "Pin 15 ="; P15
PRINT "Pin 13 ="; P13
PRINT "Pin 12 ="; P12
PRINT "Pin 10 ="; P10
PRINT "Pin 11 ="; P11

END 

