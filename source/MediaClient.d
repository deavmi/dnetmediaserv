module MediaClient;

import std.socket;
import core.thread;
import bmessage;
import gogga;
import std.conv : to;
import std.digest.md;

public final class MediaClient : Thread
{
    /* Client connection */
    private Socket socket;

    /**
    * Constructs a new MediaClient with the given Socket
    */
    this(Socket client)
    {
        super(&worker);
        this.socket = client;

        gprintln("New MediaClient: "~to!(string)(this));

        start();
    }

    /**
    * Worker
    */
    private void worker()
    {
        while(true)
        {
            /* TODO: Implement me */
            gprintln("Awaiting command from client...");

            /* Await a command from the client */
            byte[] commandBytes;
            receiveMessage(socket, commandBytes);
            gprintln("Received command (bytes): "~to!(string)(commandBytes));

            /* Process the command */
            processCommand(commandBytes);
        }
    }

    private void processCommand(byte[] commandBytes)
    {
        /* Get the command */
        byte command = commandBytes[0];

        /* The response */
        byte[] responseBytes;

        /* If the user wants to upload a file */
        if(command == 0)
        {
            /* Read the filename length in (little endian) */
            byte[] filenameLengthBytes = commandBytes[1..5];
            int filenameLength = *cast(int*)filenameLengthBytes.ptr;
            
            /* Read in `filenameLength` bytes */
            string filename = cast(string)commandBytes[5..cast(uint)filenameLength];
            gprintln("Uploading data with filename '"~filename~"'...");

            /* Read the file length in (TODO: Offset below) */
            byte[] fileLengthBytes = commandBytes[5+cast(uint)filenameLength..5+cast(uint)filenameLength+4];
            int fileLength = *cast(int*)fileLengthBytes.ptr;
            gprintln("File length: "~to!(string)(fileLength)~" bytes");

            /* Read in `fileLength` bytes */
            byte[] fileBytes = commandBytes[5+cast(uint)filenameLength+4..5+cast(uint)filenameLength+4+fileLength];
            
            /* Hash filename+file to generate item key */
            byte[] hashItem = cast(byte[])filename~fileBytes;
            ubyte[] hash = new MD5Digest().digest(hashItem);
            gprintln("Hash is: "~toHexString(hash), DebugType.WARNING);

            /* TODO: Make a directory named after the hash and store file data in it and named as filename */

            /* Return the hash as the media handle */
            responseBytes ~= cast(byte[])hash;
        }
        /* If the user wants to fetch a media item */
        else if(command == 1)
        {
            /* TODO: Read in the hash */
            byte[] hashLengthBytes = commandBytes[1..5];
            int hashLength = *cast(int*)hashLengthBytes.ptr;
            string hashString = toHexString(cast(ubyte[])commandBytes[5..5+hashLength]);
            

            /* TODO: Fetch the filename */
            /* TODO: Fetch the file bytes */

            /* Read the filename length in */
            byte[] filenameLengthBytes = commandBytes[1..4];
            /* TODO: Get length */

            /* Read in `filenameLength` bytes */
        }
        /* Unknown command */
        else
        {
            
        }

        /* TODO: Send response */
        sendMessage(socket, responseBytes);
    }

    override public string toString()
    {
        return "MediaClient ["~to!(string)(socket)~"]";
    }
}