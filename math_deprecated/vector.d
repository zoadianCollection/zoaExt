/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 */
module ext.math.vector;

import std.stdio;
import std.math;
import std.random;
import std.traits;



private void _isVector(int X, U)(Vector!(X, U) vec) {}
/// evaluates to true if T is a Vector. otherwise false.
template isVector(T) 
{
	enum isVector = is(typeof(_isVector(T.init)));
}
unittest
{
	assert(isVector!(Vector!(3, float)) == true);
	assert(isVector!(int) == false);
}







///
struct Vector(int D, T = float) if(D >= 2)
{
public:
	///
	static const int dimension = D;
	///
	alias T type;

private:
	T[D] _vec;

private:
	template coord_to_index(char c)
	{
		static if(c == 'x') enum coord_to_index = 0;
		else static if(c == 'y') enum coord_to_index = 1;
		else static if(c == 'z' && D >= 3) enum coord_to_index = 2;
		else static if(c == 'w' && D >= 4) enum coord_to_index = 3;
		else static assert(false, "failed to swizzle "~ c);
	}

	void swizzleArray(int i, string s, int size)(ref T[size] result)
	{
		static if(s.length > 0)
		{
			result[i] = this._vec[coord_to_index!(s[0])];
			swizzleArray!(i+1, s[1..$])(result);
		}
	}

	//static void _isTypeCompatibleTo(int X, U)(Vector!(X, U) v) if(isImplicitlyConvertible(U,T)){}
	//static void _isDimensionCompatibleTo(int X, U)(Vector!(X,U) v) if(X <= this.dimension){}

	//template isTypeCompatibleTo(V)
	//{
	//    enum isTypeCompatibleTo = is(typeof(_isTypeCompatibleTo(V.init)));
	//}
	//
	//template isDimensionCompatibleTo(V) if(isVector!V)
	//{
	//    enum isDimensionCompatibleTo = is(typeof(_isDimensionCompatibleTo(V.init)));
	//}

public:
	/**
	name swizzle

	returns type T if string.length == 1, else it returns T[]		

	Example:
	---
	auto v1 = Vector!(4,int)(12,13,14,15);
	assert(v1.x == 12);
	assert(v1.y == 13);
	assert(v1.z == 14);
	assert(v1.w == 15);
	auto swizz = v1.xwyzzywx;
	assert(swizz.length == 8);
	assert(swizz[0] == 12);
	assert(swizz[1] == 15);
	assert(swizz[2] == 13);
	assert(swizz[3] == 14);
	assert(swizz[4] == 14);
	assert(swizz[5] == 13);
	assert(swizz[6] == 15);
	assert(swizz[7] == 12);
	---
	*/
	auto opDispatch(string s)()
	{
		static if(s.length == 1)
		{
			return this._vec[coord_to_index!(s[0])];
		}
		else if(s.length > 1)
		{
			T[s.length] ret;
			swizzleArray!(0,s)(ret);
			return ret;
		}
	}
	unittest
	{
		auto v1 = Vector!(4,int)(12,13,14,15);
		assert(v1.x == 12);
		assert(v1.y == 13);
		assert(v1.z == 14);
		assert(v1.w == 15);
		auto swizz = v1.xwyzzywx;
		assert(swizz.length == 8);
		assert(swizz[0] == 12);
		assert(swizz[1] == 15);
		assert(swizz[2] == 13);
		assert(swizz[3] == 14);
		assert(swizz[4] == 14);
		assert(swizz[5] == 13);
		assert(swizz[6] == 15);
		assert(swizz[7] == 12);
	}

public:
	///
	this(in T[D] ar ...)
	{
		this._vec = ar;
	}
	unittest
	{
		auto h = Vector!(2,int)(12,13);
		assert(h._vec[0] == 12);
		assert(h._vec[1] == 13);
		assert(h._vec.length == 2);
		auto h1 = Vector!(3,int)([12,13,14]);
		assert(h1._vec[0] == 12);
		assert(h1._vec[1] == 13);
		assert(h1._vec[2] == 14);
		assert(h1._vec.length == 3);
	}

	///
	this(in Vector v)
	{
		this._vec = v._vec;
	}
	unittest
	{
		auto h = Vector!(2,int)(12,13);
		auto h1 = Vector!(2,int)(h);
		assert(h1._vec[0] == 12);
		assert(h1._vec[1] == 13);
	}

public:
	///
	T opIndex(size_t i) const
	{
		return this._vec[i];
	}
    unittest
    {
		auto v = Vector!(3,int)(1,2,4);
		assert(v[0] == 1);
		assert(v[1] == 2);
		assert(v[2] == 4);
    }

	///
    auto opSlice(size_t a, size_t b) const
    {
        return this._vec[a..b];
    }
    unittest
    {
		auto v = Vector!(3,int)(1,2,4);
		auto v2 = v[0..3];
		assert(v2[0] == 1.0f);
		assert(v2[1] == 2.0f);
		assert(v2[2] == 4.0f);
		assert(v2.length == 3);
		auto v3 = v[0..2];
		assert(v3[0] == 1.0f);
		assert(v3[1] == 2.0f);
		assert(v3.length == 2);
    }

	///
    T opIndexAssign(T value, size_t i)
    {
        return this._vec[i] = value;
    }
    unittest
    {
		auto v = Vector!(3,int)(1,2,4);
		v[0] = 6;
		v[1] = 7;
		assert(v._vec[0] == 6);
		assert(v._vec[1] == 7);
    }

	///
    const bool opEquals(V)(in V v) if (isVector!V && this.dimension == V.dimension)
    {        
        return this._vec == v._vec;
    }
	unittest
	{
		auto v1 = Vector!(3,int)(1,2,4);
		auto v2 = Vector!(3,int)(1,2,4);
		auto v3 = Vector!(3,int)(1,3,4);
		assert(v1 == v2);
		assert(v1 != v3);
		assert(v2 != v3);
	}

	/// -
	Vector opUnary(string op)() const
	if(op == "-")
	{
		auto nvec = Vector(this);
		foreach(i; 0..this.dimension)
		{
			nvec._vec[i] = -this._vec[i];
		}
		return nvec;
	}
	unittest
	{        
		auto v = Vector!(3,int)(1,2,4);
		auto v2 = -v;
		assert(v2._vec[0] == -1.0f);
		assert(v2._vec[1] == -2.0f);
		assert(v2._vec[2] == -4.0f);
	}

	/// + -
    Vector opBinary(string op, V)(in V v) const
	if(((op == "+") || (op == "-")) && isVector!V )
	{
		auto nvec = Vector(this);
		foreach(i; 0..this.dimension)
		{
			mixin("nvec._vec[i]" ~op~ "= v._vec[i];");
		}
		return nvec;
	}
    unittest
    {
		auto v1 = Vector!(3,int)(1,2,4);
        auto v2 = Vector!(3,int)(3,4,5);
        auto v3 = v1+v2;
        assert(v3._vec[0] == 4);
        assert(v3._vec[1] == 6);
        assert(v3._vec[2] == 9);
        auto v4 = v2-v1;
        assert(v4._vec[0] == 2);
        assert(v4._vec[1] == 2);
        assert(v4._vec[2] == 1);

		auto v5 = Vector!(3,ulong)(ulong.max,2L,4);
		auto v6 = v2+v5;
		auto v7 = v5+v2;
    }

	/// + - * /
    Vector opBinary(string op)(in T r) const
	if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	in
	{
		static if(op == "/")
			assert(r != 0);
	}
	body
	{
		auto nvec = Vector(this);
		foreach(i; 0..this.dimension)
		{
			mixin("nvec._vec[i]" ~op~ "= cast(T)r;");
		}
		return nvec;
	}
    unittest
    {
        auto v = Vector!(3,int)(4,6,8);
        auto v1 = v+2;
        assert(v1._vec[0] == 6);
        assert(v1._vec[1] == 8);
        assert(v1._vec[2] == 10);
        auto v2 = v-2;
        assert(v2._vec[0] == 2);
        assert(v2._vec[1] == 4);
        assert(v2._vec[2] == 6);
        auto v3 = v*2;
        assert(v3._vec[0] == 8);
        assert(v3._vec[1] == 12);
        assert(v3._vec[2] == 16);
        auto v4 = v/2;
        assert(v4._vec[0] == 2);
        assert(v4._vec[1] == 3);
        assert(v4._vec[2] == 4);
    }

	/// DotProduct / Mul two Vectors *
	T opBinary(string op)(in Vector v) const
	if(op == "*")
	{
		return this.dotProduct(v);
	}
    unittest
    {
        auto v1 = Vector!(3,int)(1,2,3);
        auto v2 = Vector!(3,int)(3,4,5);
        auto vR = v1 * v2;
        assert(vR == 26);
    }

	/// AddAssign / SubAssign / MulAssign / DivAssign a scalar to all Vector Rows + - * /
	void opOpAssign(string op)(in T r)
	if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	in
	{
		static if(op == "/=")
			assert(r != 0);
	}
	body
	{
		foreach(i; 0..this.dimension)
		{
			mixin("this._vec[i]" ~op~ "= cast(T)r;");
		}
	}	
    unittest
    {
        auto v1 = Vector!(3,int)(4,6,8);
        auto v2 = Vector!(3,int)(4,6,8);
        auto v3 = Vector!(3,int)(4,6,8);
        auto v4 = Vector!(3,int)(4,6,8);
        v1+=2;
        assert(v1._vec[0] == 6);
        assert(v1._vec[1] == 8);
        assert(v1._vec[2] == 10);
        v2-=2;
        assert(v2._vec[0] == 2);
        assert(v2._vec[1] == 4);
        assert(v2._vec[2] == 6);
        v3*=2;
        assert(v3._vec[0] == 8);
        assert(v3._vec[1] == 12);
        assert(v3._vec[2] == 16);
        v4/=2;
        assert(v4._vec[0] == 2);
        assert(v4._vec[1] == 3);
        assert(v4._vec[2] == 4);
    }


	/**
		AddAssign / SubAssign / MulAssign / DivAssign same rows. 
		
		Example:
		---
		v1[0] += v2[0]; 
		v1[1] += v2[1]; 
		...
		---
	*/
    void opOpAssign(string op)(in Vector v)
	if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	in
	{
		static if(op == "/")    
		{
			foreach(i; 0..this.dimension)
			{
				assert(v._vec[i] != 0);
			}               
		}
	}
	body
	{
		foreach(i; 0..this.dimension)
		{
			mixin("this._vec[i]" ~op~ "=v._vec[i];");
		}
	}
    unittest
    {
        auto v1 = Vector!(3,int)(4,6,8);
        auto v2 = Vector!(3,int)(4,6,8);
        auto v3 = Vector!(3,int)(4,6,8);
        auto v4 = Vector!(3,int)(4,6,8);
        auto vv = Vector!(3,int)(2,2,2);
        v1+=vv;
        assert(v1._vec[0] == 6);
        assert(v1._vec[1] == 8);
        assert(v1._vec[2] == 10);
        v2-=vv;
        assert(v2._vec[0] == 2);
        assert(v2._vec[1] == 4);
        assert(v2._vec[2] == 6);
        v3*=vv;
        assert(v3._vec[0] == 8);
        assert(v3._vec[1] == 12);
        assert(v3._vec[2] == 16);
        v4/=vv;
        assert(v4._vec[0] == 2);
        assert(v4._vec[1] == 3);
        assert(v4._vec[2] == 4);
    }

public:
	///Length / Magnitude
    @property real length() const
    {
        real sum = 0;
        foreach(i; 0..this.dimension)
        {
            sum += this._vec[i]^^2;
        }
        return sqrt(sum);
    }
    unittest
    {
        auto v1 = Vector!(3,int)(10,0,0);
        assert(v1.length == 10);
        auto v2 = Vector!(3,int)(0,10,0);
        assert(v2.length == 10);
        auto v3 = Vector!(3,int)(0,0,10);
        assert(v3.length == 10);
        auto v4 = Vector!(4,float)(100,100,100,100);
        assert(v4.length == 200);
    }

	/// Squared Length / Squared Magnitude
    @property T length2() const
    {
        T sum = 0;
        foreach(i; 0..this.dimension)
        {
            sum += (this._vec[i]*this._vec[i]);
        }
        return sum;
    }
    unittest
    {		
        auto v1 = Vector!(3,int)(10,0,0);
		assert(v1.length2 == 100);
        auto v2 = Vector!(3,int)(0,10,0);
        assert(v2.length2 == 100);
        auto v3 = Vector!(3,int)(0,0,10);
        assert(v3.length2 == 100);
        auto v4 = Vector!(4,float)(100,100,100,100);
        assert(v4.length2 == 40000);
    }

	/// Distance
    real distance(V)(in V vec) const
	if( isVector!V )
    {
        return (this-vec).length;    
    }
	import std.stdio;
	unittest
	{
		auto v1 = Vector!(3,int)(4,6,8);
		auto v2 = Vector!(3,float)(2,4,6);
		auto ret = v1.distance(v2);
		//assert(ret == 3.4641);
	}

	/// Squared Distance
    real distance2(V)(in V vec) const
	if( isVector!V )
    {
        return (this-vec).length2;    
    }
	unittest
	{
		auto v1 = Vector!(3,int)(4,6,8);
		auto v2 = Vector!(3,float)(2,4,6);
		auto ret = v1.distance2(v2);
		assert(ret == 12);
	}

	///
    T dotProduct(in Vector v) const
    {
        T sum = 0;
        foreach(i; 0..this.dimension)
        {
            sum += this._vec[i]*v._vec[i];
        }
        return sum;
    }
    unittest
    {
        auto v1 = Vector!(3,int)(1,2,3);
        auto v2 = Vector!(3,int)(3,4,5);
        auto vR = v1.dotProduct(v2);
        assert(vR == 26);
    }

	///
    T absDotProduct(in Vector v) const
    {
        T sum = 0;
        foreach(i; 0..this.dimension)
        {
            sum += abs(this._vec[i]*v._vec[i]);
        }
        return sum;
    }
    unittest
    {
        auto v1 = Vector!(3,int)(1,2,3);
        auto v2 = Vector!(3,int)(-3,4,5);
        auto vR = v1.dotProduct(v2);
        assert(vR == 20);
    }

	/**
		A random value between 0 and 100 is assigned to each row
	*/
    void randomise()
	{
		Random gen;
        foreach(i; 0..this.dimension)
        {
    		this._vec[i]  = cast(T)uniform(0.0f, 100.0f, gen);
        }
	}

	/**
		Bugs: if Vector type is not floating point, it might not normalise correctly
	*/
	void normalise() 
	{     
		auto l = this.length;
		if(l != 0 /*&& !isNaN(l) && !isInfinity(l)*/)
		{
			foreach(i; 0..this.dimension)
			{
				this._vec[i] /= l;
			}
		}
	}
	unittest
	{
		//auto v1 = Vector!(4,int)(4,5,14,4);
		//v1.normalise();
		//writeln(v1._vec);
		//assert(v1.length == 1);

		auto v2 = Vector!(4,float)(100,100,100,100);
		assert(v2.length != 1);
		v2.normalise();
		assert(v2.length == 1);
	}

	/**
		Bugs: if Vector type is not floating point, it might not normalise correctly
	*/
    Vector normalisedCopy() const
    {
		auto nvec = Vector(this);
        nvec.normalise();
        return nvec;
    }
    unittest
    {
        auto v1 = Vector!(4,float)(100,100,100,100);
        assert(v1.length() != 1);
        auto vC = v1.normalisedCopy();
        assert(vC.length() == 1);
    }

	///
    static if(D == 3)
    {
        Vector crossProduct(in Vector v)
        {
            return Vector(
						  this._vec[1] * v[2] - this._vec[2] * v[1],
						  this._vec[2] * v[0] - this._vec[0] * v[2],
						  this._vec[0] * v[1] - this._vec[1] * v[0]
						  );
        }
        unittest
        {
            auto v1 = Vector!(3,int)(1,2,3);
            auto v2 = Vector!(3,int)(3,4,5);
            auto vR = v1.crossProduct(v2);
            assert(vR == Vector!(3,int)(-2,4,-2));
        }

    }
    else
    {
		//wedgeproduct
    }

	/**
		Bugs: if Vector type is not floating point, it may not returned vector might not be the currect midpoint
	*/
    Vector midPoint() const
    {
		auto nvec = Vector(this);
        nvec /= 2;
        return  nvec;   
    }
	unittest
	{
		auto v1 = Vector!(3,int)(2,4,6);
		auto v2 = v1.midPoint();
		assert(v2._vec[0] == 1);
		assert(v2._vec[1] == 2);
		assert(v2._vec[2] == 3);
	}

	/**
		For each Row, it picks the Min Value of both.

		If Vector types are different, it will cast the parameters type to the Vector's type it is applied to
	*/
    void makeFloor(V)(in V v)
	if( isVector!V )
    {
        foreach(i; 0..this.dimension)
        {
        	if( v._vec[i] < this._vec[i] )
			{ 
				this._vec[i] = cast(T)v._vec[i];
			}
        }
    }
	unittest
	{
		auto v1 = Vector!(3,int)(1,2,3);
		auto v2 = Vector!(3,float)(3,2,1);
		v1.makeFloor(v2);
		assert(v1._vec[0] == 1);
		assert(v1._vec[1] == 2);
		assert(v1._vec[2] == 1);
	}

	/**
		For each Row, it picks the Max Value of both.

		If Vector types are different, it will cast the parameters type to the Vector's type it is applied to
	*/
    void makeCeil(V)(in V v)
	if( isVector!V )
    {
        foreach(i; 0..this.dimension)
        {
            if( v._vec[i] > this._vec[i] )
			{ 
				this._vec[i] = cast(T)v._vec[i];
			}
        }
    }
	unittest
	{
		auto v1 = Vector!(3,int)(1,2,3);
		auto v2 = Vector!(3,float)(3,2,1);
		v1.makeCeil(v2);
		assert(v1._vec[0] == 3);
		assert(v1._vec[1] == 2);
		assert(v1._vec[2] == 3);
	}

    ///
    T angleBetween(V)(in V v) const
	if( isVector!V )
    {
		auto r = cast(real)this.normalisedCopy().dotProduct(v.normalisedCopy());
        return cast(T)acos(r);
    }
    unittest
    {
        auto v1 = Vector!(3,int)(1,2,3);
        auto v2 = Vector!(3,int)(3,4,5);
        auto vR = v1.angleBetween(v2);
        //assert(vR == 0.225726);
    }

	///
	bool isZeroLength() const
	{
		return (this.length == 0);
	}
	unittest
	{
		auto v1 = Vector!(3,int)(1,2,3);
		auto v2 = Vector!(3,int)(0,0,0);
		assert(v1.isZeroLength() == false);
		assert(v2.isZeroLength() == true);
	}

	///
	@property bool isNaN() const
	{
		foreach(i; 0..this.dimension)
		{
			if(std.math.isNaN(this._vec[i]))
			{
				return true;
			}
		}
		return false;
	}
	unittest
	{
		auto v1 = Vector!(3,float)(1.0f,2.0f,3.0f);
		auto v2 = Vector!(3,float)(float.nan,1.0f,23.0f);
		assert(v1.isNaN == false);
		assert(v2.isNaN == true);
	}

    ///
	@property bool isInfinity() const
	{
		foreach(i; 0..this.dimension)
		{
			if(std.math.isInfinity(this._vec[i]))
			{
				return true;
			}
		}
		return false;
	}
	unittest
	{
		auto v1 = Vector!(3,float)(1.0f,2.0f,3.0f);
		auto v2 = Vector!(3,float)(float.infinity,1.0f,23.0f);
		assert(v1.isInfinity == false);
		assert(v2.isInfinity == true);
	}

    ///
    @property auto ptr()
    {
        return this._vec.ptr;
    }
	unittest
	{
		auto v1 = Vector!(3,int)(1,2,3);
		auto p = v1.ptr;
		assert(p !is null);
	}

    ///
    void clear(T value) 
    {
        foreach(i; 0..this.dimension) {
			this._vec[i] = value;
        }
    }
	unittest
	{
		auto v1 = Vector!(3,int)(1,2,3);
		v1.clear(7);
		assert(v1._vec[0] == 7);
		assert(v1._vec[1] == 7);
		assert(v1._vec[2] == 7);
	}
}


unittest
{
	auto v1 = Vector!(2,int)(1,2);
	auto v2 = Vector!(2,long)(1,2);
	auto v3 = Vector!(2,float)(1,2);
	auto v4 = Vector!(2,double)(1,2);
	auto v5 = Vector!(2,real)(1,2);
}