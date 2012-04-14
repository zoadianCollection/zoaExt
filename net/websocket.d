/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 */
module ext.net.websocket;

import std.md5;
import std.base64;
import util.sha;

import std.conv;
import std.string;
import ext.net.base;


/**
 *
 */
class WebsocketProtocol : IProtocol
{
public:	
	@property void socket(Socket socket){ this._socket = socket; }

	ubyte[] receive(ubyte[] data)
	{
		this.receiveBuffer ~= data;
		
		if(!this.handshake)
		{
			//create handshake
			if(count(this.receiveBuffer, "\r\n\r\n") > 0)
			{
				if (auto key = createKey10(cast(string)this.receiveBuffer))
				{
					handshake = true;
					debug
					{
						writeln("Did Websocket Handshake");
					}
					//send handshake
					auto response = "HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: "~ key ~"\r\nSec-WebSocket-Protocol: chat\r\n";
					
					assert(this._socket !is null && this._socket.isAlive());
					this._socket.send(response);
					return null;
				}
			}
		}
		else
		{
			//parse frames of websocket stream
		}
		return null;
	}
	
	ubyte[] send(ubyte[] data)
	{
		this.sendBuffer ~= data;
		return null;
	}
	
private:	
	bool handshake = false;
	ubyte[] receiveBuffer;
	ubyte[] sendBuffer;
	Socket _socket;
}

/**
 * http://tools.ietf.org/html/draft-ietf-hybi-thewebsocketprotocol-10
 */
string createKey10(string header)
{
	string response = "";
	auto lines = splitLines(header);
	foreach(line; lines) 
	{
		auto pair = split(line, ":");
		
		if(pair.length != 2)
		{
			continue;
		}
		
		if(toLower(strip(pair[0])) == "sec-websocket-key")
		{
			writeln("########");
			string key = strip(pair[1]) ~ "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
			
			string encoded = cast(string)Base64.encode(cast(ubyte[])SHA1(key));
			return encoded;			
		}
	}
		
	return "";
}
unittest
{
	ubyte[] data = cast(ubyte[])SHA1("dGhlIHNhbXBsZSBub25jZQ==258EAFA5-E914-47DA-95CA-C5AB0DC85B11");
	assert(data == [0xb3, 0x7a, 0x4f, 0x2c, 0xc0, 0x62, 0x4f, 0x16, 0x90, 0xf6, 0x46, 0x06, 0xcf, 0x38, 0x59, 0x45, 0xb2, 0xbe, 0xc4, 0xea]);
	auto t = Base64.encode(data); 
	assert(t == cast(ubyte[])"s3pPLMBiTxaQ9kYGzzhZRbK+xOo=");
}
unittest
{
	string header = "GET /chat HTTP/1.1\r\nHost: server.example.com\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\nSec-WebSocket-Origin: http://example.com\r\nSec-WebSocket-Protocol: chat, superchat\r\nSec-WebSocket-Version: 8\r\n";
	auto key = createKey10(header);
	assert(key == "s3pPLMBiTxaQ9kYGzzhZRbK+xOo=");
	auto response = "HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: "~ key ~"\r\nSec-WebSocket-Protocol: chat\r\n";
}





deprecated ubyte[] createDigest76(string header)
{
	auto parts = split(header, "\r\n\r\n");
	uint part_1;
	uint part_2;
	auto lines = splitLines(header);
	foreach(line; lines) 
	{
		if (line.length == 0)
		{
			break;
		}
		auto pair = split(line, ":");
		uint numeric_part;
		uint spaces;
		if (toLower(pair[0]) == "sec-websocket-key1") 
		{               
			auto s = removechars(pair[1], "^0-9");
			numeric_part = parse!(uint)(s);
			spaces = countchars(pair[1], " ")-1;
			part_1 = numeric_part/spaces;
		}
		else if (toLower(pair[0]) == "sec-websocket-key2")
		{    
			auto s = removechars(pair[1], "^0-9");
			numeric_part = parse!(uint)(s);
			spaces = countchars(pair[1], " ")-1;
			part_2 = numeric_part/spaces;
		}
	}
	
	ubyte[] response;
	response.length=8;
	response[3] = part_1 & 0xFF;
	response[2] = (part_1 >> 8) & 0xFF;
	response[1] = (part_1 >> 16) & 0xFF;
	response[0] = (part_1 >> 24) & 0xFF;
	response[7] = part_2 & 0xFF;
	response[6] = (part_2 >> 8) & 0xFF;
	response[5] = (part_2 >> 16) & 0xFF;
	response[4] = (part_2 >> 24) & 0xFF;
	response ~= cast(ubyte[])parts[1][$-8..$];
	
    ubyte[16] digest;
    sum(digest, response);
	return digest.dup;
}


import std.stdio;
deprecated unittest
{
	auto hed = 
		"GET / HTTP/1.1\n
                Upgrade: WebSocket\n
                Connection: Upgrade\n
                Host: localhost:9999\n
                Origin: http://localhost:9000\n
                Sec-WebSocket-Key1: 4 @1 46546xW%0l 1 5\n
				Sec-WebSocket-Key2: 12998 5 Y3 1 .P00\n
                Cookie: session_id=691791f29e0d41d018ae5d6a1f5895b1f3158821\r\n\r\n
				^n:ds[4U ";
	auto digest = createDigest76(hed);

}
