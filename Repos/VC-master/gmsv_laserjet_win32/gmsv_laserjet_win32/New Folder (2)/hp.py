#!/usr/bin/python
import sys
import socket

if ( len(sys.argv)<3 ):
  print "Need a hostname and a message (in quotes)"
  sys.exit(1)

# Get parms
hostname = sys.argv[1]
message = sys.argv[2]

print "hp.py: homage to l0pht's hp.c"
print "-----------------------------"
print "Hostname: " + hostname
print "Message : " + message
print ""

send_string = "\033%-12345X@PJL RDYMSG DISPLAY = \""+message[:44]+"\"\r\n\033%-12345X\r\n"

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((hostname, 9100))
bytes_sent=s.send(send_string)
print "Sent %d bytes" % bytes_sent
s.close()

