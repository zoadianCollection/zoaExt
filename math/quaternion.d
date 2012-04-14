/**
* Authors: Felix Hufnagel
* Copyright: Felix Hufnagel
* License: http://www.boost.org/LICENSE_1_0.txt
*/
//quaternion vector[4] with x,y,z,w
module ext.math.quaternion;

import std.traits;
import std.math;

//
@property auto ref x(QT)(QT[4] quaternion) pure nothrow @safe
{
	return quaternion[0];
}

//
@property auto ref y(QT)(QT[4] quaternion) pure nothrow @safe
{
	return quaternion[1];
}

//
@property auto ref z(QT)(QT[4] quaternion) pure nothrow @safe
{
	return quaternion[2];
}

//
@property auto ref w(QT)(QT[4] quaternion) pure nothrow @safe
{
	return quaternion[3];
}

ref QT[4] makeIdendity(QT)(ref QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	quaternion = [0,0,0,1];
	return quaternion;
}

QT[3] xAxis(QT)(in QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	real ty = 2.0f*quaternion[1];
	real tz = 2.0f*quaternion[2];
	real twy = ty*quaternion[3];
	real twz = tz*quaternion[3];
	real txy = ty*quaternion[0];
	real txz = tz*quaternion[0];
	real tyy = ty*quaternion[1];
	real tzz = tz*quaternion[2];
	return [1.0-(tyy+tzz), txy+twx, txz-twy];
}

QT[3] yAxis(QT)(in QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	real Tx = 2.0f*quaternion[0];
	real ty = 2.0f*quaternion[1];
	real tz = 2.0f*quaternion[2];
	real twy = ty*quaternion[3];
	real twz = tz*quaternion[3];
	real txy = ty*quaternion[0];
	real txz = tz*quaternion[0];
	real tyy = ty*quaternion[1];
	real tzz = tz*quaternion[2];
	return [txy-twz, 1.0-(txx-tzz), tyz+twx];
}

QT[3] zAxis(QT)(in QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	real Tx = 2.0f*quaternion[0];
	real ty = 2.0f*quaternion[1];
	real tz = 2.0f*quaternion[2];
	real twy = ty*quaternion[3];
	real twz = tz*quaternion[3];
	real txy = ty*quaternion[0];
	real txz = tz*quaternion[0];
	real tyy = ty*quaternion[1];
	real tzz = tz*quaternion[2];
	return [txz+twy, tyz-twx, 1.0-(txx+tyy)];
}

ref QT[4] add(QT, RQT)(ref QT[4] quaternion, in RQT[4] rquaternion)  pure nothrow @safe
if (isNumeric!(QT) && isImplicitlyConvertible!(RQT, QT))
{
	foreach(i;0..4)
		quaternion[i] += rquaternion[i];
	return quaternion;
}

ref QT[4] sub(QT, RQT)(ref QT[4] quaternion, in RQT[4] rquaternion) pure nothrow @safe
if (isNumeric!(QT) && isImplicitlyConvertible!(RQT, QT))
{
	foreach(i;0..4)
		quaternion[i] -= rquaternion[i];
	return quaternion;
}

ref QT[4] mul(QT, RQT)(ref QT[4] quaternion, in RQT[4] rquaternion) pure nothrow @safe
if (isNumeric!(QT) && isImplicitlyConvertible!(RQT, QT))
{
	quaternion = [	quaternion[3] * rquaternion[0] + quaternion[0] * rquaternion[3] + quaternion[1] * rquaternion[2] - quaternion[2] * rquaternion[1],
	quaternion[3] * rquaternion[1] + quaternion[1] * rquaternion[3] + quaternion[2] * rquaternion[0] - quaternion[0] * rquaternion[2],
	quaternion[3] * rquaternion[2] + quaternion[2] * rquaternion[3] + quaternion[0] * rquaternion[1] - quaternion[1] * rquaternion[0],
	quaternion[3] * rquaternion[3] - quaternion[0] * rquaternion[0] - quaternion[1] * rquaternion[1] - quaternion[2] * rquaternion[2]];
	return quaternion;
}

ref QT[4] mul(QT, T)(ref QT[4] quaternion, in T scalar) pure nothrow @safe
if (isNumeric!(QT) && isImplicitlyConvertible!(T, QT))
{
	foreach(i;0..4)
		quaternion[i] *= scalar;
	return quaternion;
}

ref QT[4] negate(QT)(ref QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	return [-quaternion[0], -quaternion[1], -quaternion[2], -quaternion[3]];
}

QT dotProduct(QT, RQT)(in QT[4] quaternion, in RQT[4] rquaternion) pure nothrow @safe
if (isNumeric!(QT) && isImplicitlyConvertible!(RQT, QT))
{
	return quaternion[0]*rquaternion[0] + quaternion[1]*rquaternion[1] + quaternion[2]*rquaternion[2] + quaternion[3]*rquaternion[3] ;
}

QT length(QT)(in QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	return sqrt(quaternion[0]^^2 + quaternion[1]^^2 + quaternion[2]^^2 + quaternion[3]^^2);
}

QT length2(QT)(in QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	return quaternion[0]^^2 + quaternion[1]^^2 + quaternion[2]^^2 + quaternion[3]^^2;
}

ref QT[4] narmalise(QT)(ref QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	real len = quaternion.length();
	assert(len != 0);
	if(len == 0)
		return;
	real factor = 1.0 / len;

	quaternion[0] *= factor;
	quaternion[1] *= factor;
	quaternion[2] *= factor;
	quaternion[3] *= factor;
	return quaternion;
}

ref QT[4] invert(QT)(ref QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	real norm = norm();
	if(norm > 0.0f)
	{
		real invNorm = 1.0f/norm;
		return quaternion = [-quaternion[0]*invNorm, -quaternion[1]*invNorm, -quaternion[2]*invNorm, quaternion[3]*invNorm];
	}
	else
	{
		return quaternion = [0,0,0,0];
	}
}

ref QT[4] unitInvert(QT)(ref QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	return quaternion = [-quaternion[0], -quaternion[1], -quaternion[2], quaternion[3]];
}

import ext.math.vector;
QT[3] mul(QT, RVT)(in QT[4] quaternion, in RVT[3] rvector) pure nothrow @safe
if (isNumeric!(QT) && isImplicitlyConvertible!(RVT, QT))
{
	QT[3] uv;
	QT[3] uuv;
	QT[3] qvec = [quaternion[0], quaternion[1], quaternion[2]];
	uv = qvec.crossProduct(rvector.dup);
	uuv = qvec.crossProduct(uv.dup);
	uv *= (2.0*quaternion[3]);
	uuv *= 2.0;
	return v.add(uv).add(uuv);
}

real roll(QT)(in QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	return atan2(2 * (quaternion[3]*quaternion[2] + quaternion[0]*quaternion[1]), quaternion[3]^^2 - quaternion[0]^^2 + quaternion[1]^^2 - quaternion[2]^^2);
}

real pitch(QT)(in QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	return asin(2 * (quaternion[3]*quaternion[0] - quaternion[1]*quaternion[2]));
}

real yaw(QT)(in QT[4] quaternion) pure nothrow @safe
if (isNumeric!(QT))
{
	return atan2(2 * (quaternion[3]*quaternion[1] + quaternion[0]*quaternion[2]), quaternion[3]^^2 - quaternion[0]^^2 - quaternion[1]^^2 + quaternion[2]^^2);
}