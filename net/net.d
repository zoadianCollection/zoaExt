/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 *
 * A lightweight socket Wrapper.
 * NOT READY TO USE.
 */
module ext.net.base;

//##############################################

class HTTPProtocol : Protocol
{
public:    
    void send(HTTPRequest);
    void delegate (HTTPRequest) onRecv;
}

class WebsocketProtocol : Protocol
{
public:    
    void send(char[]);
    void delegate(char[]) onRecv;
}

//##############################################


/**
con.__recv ----> p1.__recv ----> p2.__recv ----> p2.OnRecv
con.__send <--- p1.__send <---- p2.__send <---- whatever func p2 implements to send
*/
abstract class Protocol
{
module:
    void OnRecv(ubyte[]); //this gehts called _ONLY_ if its the top proto in the stack
private:
    ubyte[] delegate() __recv; //called from previous proto in stack
    void delegate (ubyte[]) __send;//called from child 
}


class Connection
{
public:    
    void close();
    void push(Protocol protocol)
    {
        if(_protocols.length > 0)
        {
            this._protocols[$].__recv = protocol.__recv; // ->            
            protocol.__send = this._protocols[$].__send; // <-
            protocol.__recv = protocol.OnRecv; //link top protocol to itself
            this._protocols ~= protocol;
        }
        else
        {                
            this.__recv = protocol.__recv; // ->
            protocol.__send = this.__send; // <-
            protocol.__recv = protocol.OnRecv; //link top protocol to itself
            this._protocols ~= protocol;
        }
    }
        
public:
    ubyte[] delegate() recv;
    void send(ubyte[]);
private:
    Protocol[] _protocols;
}


class IServer
{
public:
    @property ref const Connection[] connections() const;
public:
    void delegate(Connection) onClientConnect;
    void delegate(Connection) onClientDisconnect;
private:
}

unittest
{
    //get connection from server
    auto con = new Connection();
    
    Protocol!(WebsocketProtocol, FrayGameProtocol) proto(con);
}