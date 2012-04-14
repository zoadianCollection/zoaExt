/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 */
module util.convert;
import std.stdio;

///Converts any 32bit value to a ubyte[4]
pure ubyte[] toUByte(T)(T t)
{
	static assert(T.sizeof == 4);
	int i = *cast(int*)&t;
	return [cast(ubyte)(i >>> 24),cast(ubyte)(i >>> 16),cast(ubyte)(i >>> 8),cast(ubyte)(i)];
}
unittest
{
	ubyte[] ub = toUByte(42);
	assert(ub[0] == 0);
	assert(ub[1] == 0);
	assert(ub[2] == 0);
	assert(ub[3] == 42);
	ub = toUByte(0xFFFFFFFF);
	assert(ub[0] == 255);
	assert(ub[1] == 255);
	assert(ub[2] == 255);
	assert(ub[3] == 255);
	float f = 56.7f;
	ub = toUByte(f);
	int m = toInt(ub);
	assert(*cast(float*)&m == f);
}

///
pure int toInt(ubyte[] data)
{
	if(data.length != 4)
	{
		throw new Exception("can not convert ubyte[]: not 4 bytes long");
	}
	int value = 0;
        for (int i = 0; i < 4; i++) {
            int shift = (4 - 1 - i) * 8;
            value += (data[i] & 0x000000FF) << shift;
        }
        return value;
}

///
pure uint toUInt(ubyte[] data)
{
	int i = toInt(data);
	return *cast(uint*)&i;
}

///
pure float toFloat(ubyte[] data)
{
	int i = toInt(data);
	return *cast(float*)&i;
}

/**
 * Convert any function pointer to a delegate.
 * _ From: http://www.digitalmars.com/d/archives/digitalmars/D/easily_convert_any_method_function_to_a_delegate_55827.html */
R delegate(P) toDelegate(R, P...)(R function(P) fp)
{	struct S
	{	R Go(P p) // P is the function args.
		{	return (cast(R function(P))(cast(void*)this))(p);
		}
	}
	return &(cast(S*)(cast(void*)fp)).Go;
}

unittest
{
	writeln("UNITTEST util.converts");
	//TODO: add unittests for negative values
	ubyte[] b= [0x45,0x64,0x43,0x19];
	int i = b.toInt();
	assert(i == 1164198681);
	
	ubyte[] b2= [0x45,0x64,0x43,0x19];
	uint i2 = b2.toUInt();
	assert(i2 == 1164198681);
}
