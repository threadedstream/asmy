#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <netinet/in.h>

void panic(const char* message){
	fprintf(stderr, message);
	exit(-1);
}

int main(int argc,const char* argv[]){
	int fd = 0, backlog = 5, client_size = 0;
	int clients[5];
	unsigned running = 1;
	struct sockaddr_in addr = {}, client = {};
	client_size = sizeof(client);
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	addr.sin_port = htons(8000);


	if ((fd = socket(AF_INET, SOCK_STREAM, 0)) == -1)
		panic("Could not initialize socket\n");
	
	fprintf(stdout, "Successfully initialized socket\n");
	fprintf(stdout, "Binding on localhost...\n");

	if (bind(fd, (const struct sockaddr*) &addr, sizeof(addr)) == -1)
		panic("Could not bind\n");

	fprintf(stdout, "Successfully bound on localhost\n");
	fprintf(stdout, "Waiting for someone to connect...\n");
	if ((listen(fd, backlog)) == -1)
		panic("Failed to listen\n");

	int i = 0;
	
	while (running){
		if ((clients[i] = accept(fd, (struct sockaddr* )&client, &client_size)) == -1)
			panic("Failed to accept the client\n");

		i++;
		fprintf(stdout, "Just connected: %u:%u", client.sin_addr.s_addr, client.sin_port);
	}	
	return 0;
}	
