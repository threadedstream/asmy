#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdarg.h>
#include <signal.h>
#include <errno.h>


#define SIGINT 2


typedef struct{
	int fd; 
	int backlog; 
	struct sockaddr_in addr;
	char* response;
	char* request;
}server_conf;

server_conf server = {0};

void panic(const char* message){
	fprintf(stderr, message);
	exit(-1);
}

void finish_poll(int sig);

int main(int argc,const char* argv[]){
	server.backlog = 5; int client_size = 16, code = 0;
	const char* message = "<h1>Hello, Assembly Hero</h1>";
	//allocate space for response
	server.response = malloc(100);
	sprintf(server.response,"HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nConnection: Keep-Alive\r\n\r\n%s", message);
	int clients[5];
	unsigned running = 1;
	struct sockaddr_in addr = {}, client = {};
	client_size = sizeof(client);
	server.addr.sin_family = AF_INET;
	server.addr.sin_addr.s_addr = inet_addr("0.0.0.0");
	server.addr.sin_port = htons(8000);

	if (signal(SIGINT, finish_poll) == SIG_ERR)
		panic("Failed to setup signal handler\n");

	if ((server.fd = socket(AF_INET, SOCK_STREAM, 0)) == -1)
		panic("Could not initialize socket\n");

	if ((code = setsockopt(server.fd, SOL_SOCKET, SO_REUSEADDR, &(int){0x1}, 0x4)) == -1){
		printf("%d\n", code);
		panic("setsockopt failed\n");
	}


	fprintf(stdout, "Successfully initialized socket\n");
	fprintf(stdout, "Binding on localhost...\n");

	if (bind(server.fd, (const struct sockaddr*) &server.addr, sizeof(server.addr)) == -1)
		panic("Could not bind\n");

	fprintf(stdout, "Successfully bound on localhost\n");
	fprintf(stdout, "Waiting for someone to connect...\n");
	if ((listen(server.fd, server.backlog)) == -1)
		panic("Failed to listen\n");

	int i = 0;
	//allocate space for request
	char *request = malloc(120);
	while (running){
		if ((clients[i] = accept(server.fd, (struct sockaddr* )&client, &client_size)) == -1)
			panic("Failed to accept the client\n");

		if (recvfrom(clients[i], server.request, 120, 0x1, NULL, &client_size) == -1){
			printf("%d\n", errno);
		}

		fprintf(stdout, "Request: %s\n", request);
		if (sendto(clients[i], server.response, strlen(server.response), 0x0, (const struct sockaddr*)&client, sizeof(client)) == -1)
			panic("Failed to send data to the client");
		i++;
	}	
	return 0;
}	

void finish_poll(int sig){
	printf("signal caught with sig: %d\n", sig);
	free((void*)server.response);
	free((void*)server.request);
	if (close(server.fd) == -1)
		panic("Could not close a socket\n");
	
	//RAII
	exit(1);
	
	return;
}

