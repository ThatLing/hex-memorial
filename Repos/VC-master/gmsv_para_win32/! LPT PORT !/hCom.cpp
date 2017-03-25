char *pcPort = "LPT1";
char ch = 'C';
unsigned long b;// no. of bytes written
hCom = CreateFile( pcPort,
GENERIC_READ | GENERIC_WRITE,
0,
NULL,
OPEN_EXISTING,
0,
NULL
);

if (hCom == INVALID_HANDLE_VALUE)
{
// Handle the error.
printf ("CreateFile failed with error %d.", GetLastError());
return (1);
}
else
printf("\nCreateFile Succeeded...");

// Now Writing the char to port

if(WriteFile(hCom, &ch, 1, &b, NULL))
printf("\nWriteFile Succeeded...");
else
printf("\nWriteFile Failed, Error Code : %d\n", GetLastError());