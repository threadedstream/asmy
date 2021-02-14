#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>


void panic(const char* message){
	fprintf(stderr, message);
}

int main(int argc,const char* argv[]){
	int fd = 0;

	if ((fd = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		panic("Could not initialize socket");
	}else{fprintf(stdout, "Initialization is successful");}

	return 0;
}	
