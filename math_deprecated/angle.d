/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 */
module ext.math.angle;

import std.math;

///
struct Radian
{
public:
	this(T)(in T r = 0)						
	{ 
		static if(T == Radian)
		{
			mRad = r.mRad;
		}
		else if (T == Degree)
		{
			mRad = r.valueDegrees();
		}
		else
		{
			mRad = r; 
		}	
	}
	
		
	
	//ref Radian opAssign(in real f )      		{ mRad = f; return *this; }
	//ref Radian opAssign(in Radian r )    		{ mRad = r.mRad; return *this; }
	//ref Radian opAssign(in Degree d )    		{ mRad = d.valueRadians(); return this;	}
	//
	
	///
	Radian opUnary(string op)() const 
	if (op == "-") 	
	{ return Radian(-mRad); }
	
	///
	@property real valueDegrees() const         { return (mRad % PI_2) * PI / 180;}
	
	///
	@property real valueRadians() const         { return mRad; }
	
	///
	//@property real valueAngleUnits() const;
	
	///
	Radian opBinary(string op)(in Radian r) const
	if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	in
	{
		static if(op == "/")
			assert(r != 0);
	}
	body
	{
		mixin("return Radian(mRad"~op~"r.mRad);");
	}
	
	///
	Radian opBinary(string op)(in Degree d) const
	if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	in
	{
		static if(op == "/")
			assert(d != 0);
	}
	body
	{
		mixin("return Radian(mRad"~op~"d.valueRadians());");
	}
	
	///
	//~ Radian opBinary(string op, T)(T r) const
	//~ if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	//~ in
	//~ {
		//~ static if(op == "/")
		//~ assert(r != 0);
	//~ }
	//~ body
	//~ {
		//~ mixin("return Radian(mRad"~op~"r);");
	//~ } 
	
	///
	inout Radian opOpAssign(string op)(in Radian r)
	if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	in
	{
		static if(op == "/")
			assert(r != 0);
	}
	body
	{
		mixin("this.mRad"~op~"r.mRad;");
		return this;
	}
	
	///
	inout Radian opOpAssign(string op)(in Degree d)
	if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	in
	{
		static if(op == "/")
			assert(d != 0);
	}
	body
	{
		mixin("this.mRad"~op~"d.valueRadians();");
		return this;
	}
	
	///
	//~ Radian opOpAssign(string op, T)(T r)
	//~ if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	//~ in
	//~ {
		//~ static if(op == "/")
		//~ assert(r != 0);
	//~ }
	//~ body
	//~ {
		//~ mixin("this.mRad"~op~"r;");
		//~ return this;
	//~ } 

	///
	const bool opEquals(const ref Radian r) const
	{
		return this.mRad == r.mRad;
	}
	
	///
	const bool opEquals(in Degree d) const
	{
		return this.mRad == d.valueRadians();
	}
	
	///
	//~ const bool opEquals(real r) const
	//~ {
		//~ return this.mRad == r;
	//~ }
	
	///
	int opCmp(in Radian r) const 
	{ 
		if(mRad > r.mRad) return +1; if(mRad == r.mRad) return 0; return -1;  
	}
	
	///
	int opCmp(in Degree d) const
	{ 
		if(mRad > d.valueRadians()) return +1; if(mRad == d.valueRadians()) return 0; return -1;  
	}
	
	///
	//~ int opCmp(T)(T r) const 
	//~ { 
		//~ if(mRad > r) return +1; if(mRad == r) return 0; return -1;  
	//~ }
	
	///
    @property auto ptr()
    {
        return this.mRad;
    }
	
private:    
    real mRad;
}

///
struct Degree
{
public:
	this(T)(T r = 0)							
	{
		static if(T == Degree)
		{
			mDeg = r.mDeg;
		}
		else if(T == Radian)
		{
			mDeg = r.valueDegrees();
		}
		else
		{
			mDeg = r; 
		}
	}
	
		
	
	//ref Degree opAssign(in real f )      		{ mDeg = f; return *this; }
	//ref Degree opAssign(in Degree r )    		{ mDeg = r.mDeg; return *this; }
	//ref Degree opAssign(in Radian d )    		{ mDeg = d.valueDegrees(); return this;	}
	//
	
	///
	Degree opUnary(string op)() const 
	if (op == "-") 	
	{ return Degree(-mDeg); }
	
	///
	@property real valueRadians() const         { return (mDeg % 360.0) / 180 * PI; }
	
	///
	@property real valueDegrees() const         { return mDeg; }
	
	///
	//@property real valueAngleUnits() const;
	
	///
	Degree opBinary(string op)(in Degree d) const
	if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	in
	{
		static if(op == "/")
			assert(d != 0);
	}
	body
	{
		mixin("return Degree(mDeg"~op~"d.mDeg);");
	}
	
	///
	Degree opBinary(string op)(in Radian r) const
	if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	in
	{
		static if(op == "/")
			assert(r != 0);
	}
	body
	{
		mixin("return Degree(mDeg"~op~"r.valueDegrees());");
	}
	
	///
	//~ Degree opBinary(string op, T)(T d) const
	//~ if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	//~ in
	//~ {
		//~ static if(op == "/")
		//~ assert(d != 0);
	//~ }
	//~ body
	//~ {
		//~ mixin("return Degree(mDeg"~op~"d);");
	//~ } 
	
	///
	inout Degree opOpAssign(string op)(in Degree d)
	if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	in
	{
		static if(op == "/")
			assert(d != 0);
	}
	body
	{
		mixin("this.mDeg"~op~"d.mDeg;");
		return this;
	}
	
	///
	inout Degree opOpAssign(string op)(in Radian r)
	if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	in
	{
		static if(op == "/")
			assert(r != 0);
	}
	body
	{
		mixin("this.mDeg"~op~"r.valueDegrees();");
		return this;
	}
	
	///
	//~ Degree opOpAssign(string op, T)(T d)
	//~ if((op == "+") || (op == "-") || (op == "*") || (op == "/"))
	//~ in
	//~ {
		//~ static if(op == "/")
		//~ assert(d != 0);
	//~ }
	//~ body
	//~ {
		//~ mixin("this.mDeg"~op~"d;");
		//~ return this;
	//~ } 

	///
	const bool opEquals(const ref Degree d) const
	{
		return this.mDeg == d.mDeg;
	}
	
	///
	const bool opEquals(in Radian r) const
	{
		return this.mDeg == r.valueDegrees();
	}
	
	///
	//~ const bool opEquals(real d) const
	//~ {
		//~ return this.mDeg == d;
	//~ }
	
	///
	int opCmp(in Degree d) const 
	{ 
		if(mDeg > d.mDeg) return +1; if(mDeg == d.mDeg) return 0; return -1;
	}
	
	///
	int opCmp(in Radian r) const
	{ 
		if(mDeg > r.valueDegrees()) return +1; if(mDeg == r.valueDegrees()) return 0; return -1;  
	}
	
	///
	//~ int opCmp(T)(T d) const 
	//~ { 
		//~ if(mDeg > d) return +1; if(mDeg == d) return 0; return -1;  
	//~ }
	
	///
    @property auto ptr()
    {
        return this.mDeg;
    }
private:    
    real mDeg;
}


unittest
{
	//auto deg = Degree(0);
	//assert(deg.valueDegrees = 0);
	//assert(deg.valueRadians = 0);
	//deg = 30;
	//assert(deg.valueDegrees = 30);
	//assert(deg.valueRadians = PI_4/2);
	//deg = 45;
	//assert(deg.valueDegrees = 45);
	//assert(deg.valueRadians = PI_4);
	//deg = 60;
	//assert(deg.valueDegrees = 60);
	//assert(deg.valueRadians = PI_3);
	//deg = 90;
	//assert(deg.valueDegrees = 90);
	//assert(deg.valueRadians = PI_2);
	//deg = 180;
	//assert(deg.valueDegrees = 180);
	//assert(deg.valueRadians = PI);
}


































