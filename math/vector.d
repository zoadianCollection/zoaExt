/**
* Authors: Felix Hufnagel
* Copyright: Felix Hufnagel
* License: http://www.boost.org/LICENSE_1_0.txt
*/
module ext.math.vector;

import std.traits;
import std.math;

//
@property auto ref x(VT)(ref VT[3] vector) pure nothrow @safe
{
	return vector[0];
}

//
@property auto ref y(VT)(ref VT[3] vector) pure nothrow @safe
{
	return vector[1];
}

//
@property auto ref z(VT)(ref VT[3] vector) pure nothrow @safe
{
	return vector[2];
}


///nagate
ref VT[3] makeIdendity(VT)(ref VT[3] vector) pure nothrow @safe
if (isNumeric!(VT))
{
	foreach(i;0..3)
		vector[i] = -vector[i];
	return vector;
}

//add vector
ref VT[3] add(VT, RVT)(ref VT[3] vector, in RVT[3] rvector)  pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(RVT, VT))
{
	foreach(i;0..3)
		vector[i] += rvector[i];
	return vector;
}

// sub vector
ref VT[3] sub(VT, RVT)(ref VT[3] vector, in RVT[3] rvector) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(RVT, VT))
{
	foreach(i;0..3)
		vector[i] -= rvector[i];
	return vector;
}

// add scalar
ref VT[3] add(VT, T)(ref VT[3] vector, in T scalar) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(T, VT))
{
	foreach(i;0..3)
		vector[i] += scalar;
	return vector;
}

// sub scalar
ref VT[3] sub(VT, T)(ref VT[3] vector, in T scalar) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(T, VT))
{
	foreach(i;0..3)
		vector[i] -= scalar;
	return vector;
}

// mul scalar
ref VT[3] mul(VT, T)(ref VT[3] vector, in T scalar) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(T, VT))
{
	foreach(i;0..3)
		vector[i] *= scalar;
	return vector;
}

// div scalar
ref VT[3] div(VT, T)(ref VT[3] vector, in T scalar) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(T, VT))
{
	foreach(i;0..3)
		vector[i] /= scalar;
	return vector;
}

// Length / Magnitude
real length(VT)(in VT[3] vector) pure nothrow @safe
if (isNumeric!(VT))
{
	real sum = 0;
	foreach(i; 0..3)
	{
		sum += vector[i]^^2;
	}
	return sqrt(sum);
}

// Squared Length / Squared Magnitude
VT length2(VT)(in VT[3] vector) pure nothrow @safe
if (isNumeric!(VT))
{
	VT sum = 0;
	foreach(i; 0..3)
	{
		sum += (vector[i]*this._vec[i]);
	}
	return sum;
}

//distance
real distance(VT, RVT)(in VT[3] vector, in RVT[3] rvector) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(RVT, VT))
{
	return vector.sub(rvector).length();    
}

//distance2
real distance2(VT, RVT)(in VT[3] vector, in RVT[3] rvector) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(RVT, VT))
{
	return vector.sub(rvector).length2();    
}

//dotproduct
real dotProduct(VT, RVT)(in VT[3] vector, in RVT[3] rvector) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(RVT, VT))
{
	VT sum = 0;
	foreach(i; 0..3)
	{
		sum += vector[i] * rvector[i];
	}
	return sum;
}

//absDotProduct
real dotProduct(VT, RVT)(in VT[3] vector, in RVT[3] rvector) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(RVT, VT))
{
	VT sum = 0;
	foreach(i; 0..3)
	{
		sum += abs(vector[i] * rvector[i]);
	}
	return sum;
}

// A random value between 0 and 100 is assigned to each row
ref VT[3] makeIdendity(VT)(ref VT[3] vector) pure nothrow @safe
if (isNumeric!(VT))
{
	Random gen;
	foreach(i;0..3)
		vector[i] = cast(T)uniform(0.0f, 100.0f, gen);
	return vector;
}

//normalise
ref VT[3] normalise(VT)(ref VT[3] vector) pure nothrow @safe
if (isNumeric!(VT))
{
	auto l = vector.length();
	if(l != 0 /*&& !isNaN(l) && !isInfinity(l)*/)
		foreach(i; 0..3)
			vector[i] /= l;
	return vector;
}

//crossProduct
ref VT[3] crossProduct(VT, RVT)(ref VT[3] vector, in RVT[3] rvector)  pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(RVT, VT))
{
	vector = [vector[1] * rvector[2] - vector[2] * rvector[1],
	vector[2] * rvector[0] - vector[0] * rvector[2],
	vector[0] * rvector[1] - vector[1] * rvector[0]];
	return vector;
}

//midPoint
ref VT[3] midPoint(VT)(ref VT[3] vector) pure nothrow @safe
if (isNumeric!(VT))
{
	return nvec.div(2);  
}

//makeFloor
ref VT[3] makeFloor(VT, RVT)(ref VT[3] vector, in RVT[3] rvector) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(RVT, VT))
{
	foreach(i; 0..3)
		if( rvector[i] < vector[i] )
			vector[i] = rvector[i];
	return vector;
}

//makeCeil
ref VT[3] makeCeil(VT, RVT)(ref VT[3] vector, in RVT[3] rvector) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(RVT, VT))
{
	foreach(i; 0..3)
		if( rvector[i] > vector[i] )
			vector[i] = rvector[i];
	return vector;
}

//angleBetween
VT makeCeil(VT, RVT)(in VT[3] vector, in RVT[3] rvector) pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(RVT, VT))
{
	auto r = cast(real)vector.normalise().dotProduct(rvector.normalise());
	return cast(VT)acos(r);
}

//isNaN
bool inNaN(VT)(in VT[3] vector) pure nothrow @safe
if (isNumeric!(VT))
{
	foreach(i; 0..3)
		if(std.math.isNaN(vector[i]))
			return true;
	return false;
}

//isInfinity
bool inInfinity(VT)(in VT[3] vector) pure nothrow @safe
if (isNumeric!(VT))
{
	foreach(i; 0..3)
		if(std.math.isInfinity(vector[i]))
			return true;
	return false;
}

//clear
ref VT[3] clar(VT, T)(ref VT[3] vector, in T scalar)  pure nothrow @safe
if (isNumeric!(VT) && isImplicitlyConvertible!(T, VT))
{
	foreach(i;0..3)
		vector[i] = scalar;
	return vector;
}