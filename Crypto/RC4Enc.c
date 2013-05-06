// RC4Enc.c
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
"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80";

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
	printf("[+] RC4 Shellcode Encrypter\n");

	if(argc <= 1) {
		printf("[+] Please specify an encryption key!\n");
		printf("[+] Usage: ./RC4Enc <key>\n");
		exit(-1);
	}

	unsigned char *encryption_key;
	int encryption_key_length;
	unsigned char data_byte;
	unsigned char keystream_byte;
	unsigned char encrypted_byte;
	int shellcode_length;
	int counter;

	encryption_key = (unsigned char *)argv[1];
	encryption_key_length = strlen((char *)encryption_key);

	if(encryption_key_length > 256) {
		printf("[+] Key too large. Should be <= 256 characters!\n");
		exit(-1);
	}

	InitRC4();
	GenerateKSA(encryption_key, encryption_key_length);

	shellcode_length = strlen(shellcode);
	printf("[+] Dumping RC4 Encrypted Shellcode...\n\n\"");

	for (counter = 0; counter < shellcode_length; counter++) {
		data_byte = shellcode[counter];
		keystream_byte = GetPRGAByte();
		encrypted_byte = data_byte ^ keystream_byte;

		if(counter % 12 == 0 && counter != 0) {
			printf("\"\n\"");
		}

		printf("\\x%02x", encrypted_byte);
	}

	printf("\"\n\n");
	return 1;
}