#include <sys/socket.h>
#include <sys/un.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <wordexp.h>

int
main (int argc, char* argv[])
{
	struct sockaddr_un addr;
	char buf[4096] = {0};
	int fd;
	char* path;
	char* command;

	if (argc == 2) {
		wordexp_t p;
		wordexp("$HOME/.hardstatus.ctl", &p, 0);

		path    = p.we_wordv[0];
		command = argv[1];
	}
	else if (argc == 3) {
		path    = argv[1];
		command = argv[2];
	}

	if ((fd = socket(AF_UNIX, SOCK_STREAM, 0)) == -1) {
		perror("socket error");
		exit(-1);
	}

	memset(&addr, 0, sizeof(addr));
	addr.sun_family = AF_UNIX;
	strncpy(addr.sun_path, path, sizeof(addr.sun_path)-1);

	if (connect(fd, (struct sockaddr*)&addr, sizeof(addr)) == -1) {
		perror("connect error");
		exit(-1);
	}

	send(fd, command, strlen(command), 0);
	send(fd, "\r\n", 2, 0);

	recv(fd, buf, 4096, 0);
	printf("%s", buf);

  return 0;
}
