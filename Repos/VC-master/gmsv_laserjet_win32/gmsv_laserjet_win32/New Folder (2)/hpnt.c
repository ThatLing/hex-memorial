



int main (int argc, char *argv[]) {

	memset(&dest_addr,0,sizeof(dest_addr));
	memcpy(&(dest_addr.sin_addr),host->h_addr,host->h_length);	
	
	dest_addr.sin_family = host->h_addrtype;
	dest_addr.sin_port = htons(9100);
	
	if ((sockfd = socket(AF_INET,SOCK_STREAM,0)) < 0) {
		sv_Lua->Msg("socket");
		WSACleanup();
		return 0;
	}
	
	sv_Lua->Msg("Connecting....\n");
	
	if (connect(sockfd, (struct sockaddr *)&dest_addr,sizeof(dest_addr)) == -1){
		sv_Lua->Msg("connect");
	WSACleanup();	
		exit(1);
	}
	
	strcpy(line,"\033%-12345X@PJL RDYMSG DISPLAY = \"");
	strncat(line,argv[2],16);
	strcat(line,"\"\r\n\033%-12345X\r\n");
	
	sv_Lua->Msg("Sending Data...%d\n",strlen(line));
	sv_Lua->Msg("Line: %s\n",line);
	
	bytes_sent=send(sockfd,line,strlen(line),0);
	
	sv_Lua->Msg("Sent %d bytes\n",bytes_sent);
	
	closesocket(sockfd);
	WSACleanup();
}



