import std.stdio;
import gogga;
import std.socket;
import MediaClient;

void main()
{
	gprintln("Media server is starting...");

	/* Start the server */
	startServer("");
}

void startServer(string socketPath)
{
	/* Create the socket */
	Socket serverSocket = new Socket(AddressFamily.UNIX, SocketType.STREAM, cast(ProtocolType)0);

	/* Bind to the address provided */
	serverSocket.bind(new UnixAddress(socketPath));

	/* Accept incoming connections */
	serverSocket.listen(0);

	/* Start connection accept loop */
	while(true)
	{
		/* Dequeue a connection from the connection queue */
		gprintln("Awaiting socket connection dequeue...");
		Socket client = serverSocket.accept();
		gprintln("New connection dequeued");
		
		/* Spawn a new handler for this connection */
		MediaClient mediaClient = new MediaClient(client);

		/* TODO: Add clients to list? */
	}
}
