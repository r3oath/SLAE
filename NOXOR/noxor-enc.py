#!/usr/bin/python

# NOXOR Shellcode Encoder
# www.r3oath.com
# Copyright (c) 2013 Tristan Strathearn

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

import sys

if len(sys.argv) != 2:
	print 'Usage: ./noxor-enc.py $\'shellcode\''
	sys.exit()

shellcode = (sys.argv[1])
encoded = ""

print '[+] NOXOR Shellcode Encoder by Tristan'
print '[+] www.r3oath.com'

if len(shellcode) % 2 != 0:
	print '[+] Adding NOPs to even out shellcode...'
	shellcode += ("\x90")

print '[+] Encoding...'

byteA = ""
counter = 0

for x in bytearray(shellcode):
	if counter % 2 == 0:
		byteA = x
	else:
		y = ~x
		y = y & 0xff
		XORByte = byteA^y
		NOTByte = y
		encoded += '0x'
		encoded += '%02x,' % XORByte
		encoded += '0x'
		encoded += '%02x,' % NOTByte
		
	counter += 1

print '[+] Encoded Shellcode: ' + encoded + '0xff,0xff'
print '[+] Done!'
