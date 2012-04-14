/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 */
module util.array;

public import std.array;

/**
only for dynamic arrays
all comparison is done by idendity ( is )
*/


///pop_back: removed pops element from array
ref T[] pop_back(T)(ref T[] t)
{
	t.length = t.length - 1;
	return t;
}
unittest
{
	uint[] a = [0,1,2,3,4,5,6];
	assert(a.length == 7);
	a.pop_back();
	assert(a.length == 6);	
}


///add/push_back: adds element at end of array
///alias add push_back;
ref T[] add(T)(ref T[] t, T el)
{
	t ~= el;
	return t;
}
unittest
{
	int[] a = [0,1,2,3,4,5];
	assert(a.length == 6);
	a.add(6);
	assert(a[6] == 6);
	assert(a.length == 7);	
}

///insert: inserts an element into an array at position
ref T[] insert(T)(ref T[] t, T el, uint pos)
{
	t = t[0..pos] ~ el ~ t[pos..$];
	return t;
}
unittest
{
	int[] a = [0,1,2,3,4,5];
	assert(a.length == 6);
	a.insert(6, 3);
	assert(a[0] == 0);
	assert(a[3] == 6);
	assert(a[6] == 5);
	assert(a.length == 7);	
}


///remove: removes element. keeps order
ref T[] remove(T)(ref T[] t, T el)
{
	t = t.removeAt(t.indexOf(el));
	return t;
}

///removeUO: removes element. does not keep order
ref T[] removeUO(T)(ref T[] t, T el)
{
	t = t.removeAtUO(t.indexOf(el));
	return t;
}

///removeAtUO: removes element at position. does not keep order
ref T[] removeAtUO(T)(ref T[] t, uint pos)
{
	assert(pos < t.length);
	/*
	if(pos >= t.length)
		return t;
	*/
	if (pos != t.length - 1)
	t[pos] = t[t.length - 1];
	t.length = t.length -1;
	return t;
}
unittest
{
	uint[] u= [1,2,3,4,5,6,7,8,9];
	u.removeAtUO(3);
	assert(u[0] == 1);
	assert(u[1] == 2);
	assert(u[2] == 3);
	assert(u[3] == 9);
	assert(u.length == 8);
	u.removeAtUO(5);
	assert(u[0] == 1);
	assert(u[5] == 8);
	assert(u.length == 7);
}

///removeAt: removes element at position. keeps order
ref T[] removeAt(T)(ref T[] t, uint pos)
{
	assert(pos < t.length);
	if(pos == 0 && t.length <= 1)
	{
		t.length = 0;
		return t;
	}
	if(pos == 0 && t.length > 1)
	{
		t = t[1..$];
		return t;
	}
	T[] tmp = t[0..pos];
	tmp ~= t[(pos+1)..$];
	t=tmp;
	return t;
}
unittest
{
	uint[] u= [1,2,3,4,5,6,7,8,9];
	u.removeAt(3);
	assert(u[0] == 1);
	assert(u[1] == 2);
	assert(u[2] == 3);
	assert(u[3] == 5);
	assert(u.length == 8);
	u.removeAt(5);
	assert(u[0] == 1);
	assert(u[5] == 8);
	assert(u.length == 7);
}

///has: compares by idedity ( is )
bool has(T)(T[] t, T el)
{
	foreach(T tx; t)
	{
		if(el is tx)
		{
			return true;
		}
	}
	return false;	
}
unittest
{
	uint[] u= [1,2,3,4,5,6,7,8,9];
	uint x = 6;
	assert(u.has(x) == true);
	x = 12;
	assert(u.has(x) == false);
	
	class Test
	{
	public:		
		this(uint z){c = z;}
		
		override bool opEquals(Object o)
		{
			return ((cast(Test)o).c == this.c);
		}
		
		uint c;
	}
	
	auto a = new Test(5);
	auto b = new Test(9);
	auto c = new Test(5);
	auto d = new Test(5);
	
	Test[] v = [a,b,c];
	
	assert(v.has(a) == true);
	assert(v.has(b) == true);
	assert(v.has(c) == true);
	assert(v.has(d) == false);
}


///indexOf: compares by idedity ( is )
uint indexOf(T)(T[] t, T el)
{
	for(int i=0; i<t.length; ++i)
	{
		if(el is t[i])
			return i;
	}
	throw new Exception("Element not found");
}
unittest
{
	uint[] u= [1,2,3,4,5,6,7,8,9,5];
	uint x = 5;
	assert(u.indexOf(x) == 4);
	x = 8;
	assert(u.indexOf(x) == 7);
	
	class Test
	{
	public:		
		this(uint z){c = z;}
		
		override bool opEquals(Object o)
		{
			return ((cast(Test)o).c == this.c);
		}
		
		uint c;
	}
	
	auto a = new Test(5);
	auto b = new Test(9);
	auto c = new Test(5);
	
	Test[] v = [a,b,c];
	
	assert(v.indexOf(a) == 0);
	assert(v.indexOf(b) == 1);
	assert(v.indexOf(c) == 2);	
}

/*
unittest
{
	class Test
	{
	public:		
		this(uint z){c = z;}
		
		override bool opEquals(Object o)
		{
			return ((cast(Test)o).c == this.c);
		}
		
		uint c;
	}

	auto a = new Test(5);
	auto b = new Test(9);
	auto c = new Test(5);
	auto d = a;
	
	assert(a != b);
	assert(a == c);
	assert(a == d);
	
	assert(a !is b);
	assert(a !is c);
	assert(a is d);
	assert(b != c);
	
	assert(5 == 5);
	assert(5 is 5);
}
*/
