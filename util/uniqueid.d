/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 */
module util.uniqueid;

import std.stdio;

/// Interface for a Type to be identifiable with a unique ID
interface IIdentifiable
{
	/// Returns: a unique id
	@property uint id();
}

///returns a unique id
uint uniqueid()
{
	return UniqueId.getId();
}

///
final static synchronized class UniqueId
{
public:
	///
	synchronized static uint getId()
	{
		++this.counter;
		return this.counter;
	}
	
	///
	synchronized static void reset()
	{
		this.counter = 0;
	}
	
private:	
	synchronized static uint counter = 0;
}

unittest
{
	UniqueId.reset();
	assert(uniqueid() == 1);
	assert(uniqueid() == 2);
	assert(uniqueid() == 3);
	assert(uniqueid() == 4);
	UniqueId.reset();
	assert(uniqueid() == 1);
	assert(uniqueid() == 2);
	assert(uniqueid() == 3);
	assert(uniqueid() == 4);
	UniqueId.reset();
}

