/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 */
module ext.util.cache;
 
import std.functional : toDelegate;
import std.traits;
 
///Cache Creator Function
auto Cache(DG)(DG dg){ return CacheImpl!(DG)(dg);}

///
struct CacheImpl(T)
{
private:
	ReturnType!T _c;
	T _dg;
public:
	///initialises the Cache with a delegate/function as a source
	this(T dg){this._dg = dg;}

	///updates the cached value by calling the source delegate/function
	void update(ParameterTypeTuple!T u)
	{
		this._c = this._dg(u);	
	}

	///sets a new delegate/function as source
	void setSource(T dg){this._dg = dg;}

	///returns the cached data
	@property auto data(){return this._c;}

	///returns a pointer to the cached data
	@property auto ptr(){return this._c.ptr;}
};
unittest
{
	class Test
	{
		string gen(string s){return s;}
	}
	auto t = new Test();
	auto cc = Cache(&t.gen);
	assert(cc.data == string.init);
	cc.update("test");
	assert(cc.data == "test");
	cc.update("asdf");
	assert(cc.data == "asdf");

	string genfun(){return "asdf";}
	auto cx = Cache(&genfun);
	assert(cx.data == string.init);
	cx.update();
	assert(cx.data == "asdf");
}