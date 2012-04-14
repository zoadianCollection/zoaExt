/**
* Authors: Felix Hufnagel
* Copyright: Felix Hufnagel
* License: http://www.boost.org/LICENSE_1_0.txt
*/
//column major matrix
module ext.math.matrix;

import std.traits;
import std.math;


//TODO:
//covariant
//normalise
//negate
//isuniformscale
//transformaffine



//makes identity matrix
ref MT[4][4] makeIdendity(MT)(ref MT[4][4] matrix) pure nothrow @safe
if (isNumeric!(MT))
{
	matrix = [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]];
	return matrix;
}

///is idendity
bool isIdendity(MT)(in MT[4][4] matrix) pure nothrow @safe
if (isNumeric!(MT))
{
	return matrix == [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]];
}

/// add matrix
ref MT[4][4] add(MT, MTR)(ref MT[4][4] matrix, in MTR[4][4] rmatrix)  pure nothrow @safe
if (isNumeric!(MT) && isImplicitlyConvertible!(MTR, MT))
{
	foreach(c; 0..4)
		foreach(r; 0..4)
			m[c][r] += mat[c][r];
}

/// sub matrix
ref MT[4][4] sub(MT, MTR)(ref MT[4][4] matrix, in MTR[4][4] rmatrix) pure nothrow @safe
if (isNumeric!(MT) && isImplicitlyConvertible!(MTR, MT))
{
	foreach(c; 0..4)
		foreach(r; 0..4)
			m[c][r] -= mat[c][r];
}

/// multiply matrix
ref MT[4][4] mul(MT, MTR)(ref MT[4][4] matrix, in MTR[4][4] rmatrix) pure nothrow @safe
if (isNumeric!(MT) && isImplicitlyConvertible!(MTR, MT))
{
	MT[4][4] nmatrix;
	foreach(c;0..4)
		foreach(r;0..4)
			nmatrix[c][r] = matrix[0][r]*rmatrix[c][0] + matrix[1][r]*rmatrix[c][1] + matrix[2][r]*rmatrix[c][2] + matrix[3][r]*rmatrix[c][3];
	matrix = nmatrix;
	return matrix;
}
unittest
{
	float[4][4] mat1;
	mat1.makeIdendity();
	float[4][4] mat2;
	mat2.makeIdendity();
	assert( mat1.mul(mat2) ==[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]]);
	mat2 = [[1,1,1,1],[0,1,0,0],[0,0,1,0],[0,0,0,1]];
	//TODO: ?????
	assert( mat1.mul(mat2) ==[[1,1,1,1],[0,1,0,0],[0,0,1,0],[0,0,0,1]]);
}

/// add scalar
ref MT[4][4] add(MT, T)(ref MT[4][4] matrix, in T scalar) pure nothrow @safe
if (isNumeric!(MT) && isImplicitlyConvertible!(T, MT))
{
	foreach(c; 0..4)
		foreach(r; 0..4)
			m[c][r] += scalar;
}

/// sub scalar
ref MT[4][4] sub(MT, T)(ref MT[4][4] matrix, in T scalar) pure nothrow @safe
if (isNumeric!(MT) && isImplicitlyConvertible!(T, MT))
{
	foreach(c; 0..4)
		foreach(r; 0..4)
			m[c][r] -= scalar;
}

/// transpose
ref MT[4][4] transpose(MT, MTR)(ref MT[4][4] matrix) pure nothrow @safe
{
	MT[4][4] nmatrix;
	foreach(c;0..4)
		foreach(r;0..4)
			nmatrix[r][c] = matrix[c][r];
	matrix = nmatrix;
	return matrix;
}

/// invert
MT[4][4] invert(MT, MTR)(in MT[4][4] matrix) pure nothrow @safe
{
	matrix.transpose();
	return matrix;
}

/// transpose
ref MT[4][4] add(MT, T)(ref MT[4][4] matrix, in T value) pure nothrow @safe
if (isNumeric!(MT) && isImplicitlyConvertible!(T, MT))
{
	foreach(c;0..4)
		foreach(r;0..4)
			matrix[r][c] = value;
	return matrix;
}

//translate matrix
ref MT[4][4] translate(MT, VT)(ref MT[4][4] matrix, VT[3] vec) pure nothrow @safe
if (isNumeric!(MT) && isImplicitlyConvertible!(VT, MT))
{
	matrix[3][0] += vec[0];
	matrix[3][1] += vec[1];
	matrix[3][2] += vec[2];
	return matrix;
}

//scale matrix
ref MT[4][4] scale(MT, VT)(ref MT[4][4] matrix, VT[3] vec) pure nothrow @safe
if (isNumeric!(MT) && isImplicitlyConvertible!(VT, MT))
{
	matrix[0][0] *= vec[0];
	matrix[1][1] *= vec[1];
	matrix[2][2] *= vec[2];
	return matrix;
}

///A yaw is a counterclockwise rotation of alpha about the -axis.
ref MT[4][4] yaw(MT, T)(ref MT[4][4] matrix, T alpha) pure nothrow @safe
if (isNumeric!(MT) && isImplicitlyConvertible!(T, MT))
{
	matrix[0][0] = cos(alpha);
	matrix[0][1] = sin(alpha);
	matrix[1][0] = -sin(alpha);
	matrix[1][1] = cos(alpha);
}

///A pitch is a counterclockwise rotation of beta about the -axis.
ref MT[4][4] pitch(MT, T)(ref MT[4][4] matrix, T beta) pure nothrow @safe
if (isNumeric!(MT) && isImplicitlyConvertible!(T, MT))
{
	matrix[0][0] = cos(beta);
	matrix[0][2] = -sin(beta);
	matrix[2][0] = sin(beta);
	matrix[2][2] = cos(beta);
}

///A roll is a counterclockwise rotation of gamma about the -axis.
ref MT[4][4] roll(MT, T)(ref MT[4][4] matrix, T gamma) pure nothrow @safe
if (isNumeric!(MT) && isImplicitlyConvertible!(T, MT))
{
	matrix[1][1] = cos(gamma);
	matrix[1][2] = sin(gamma);
	matrix[2][1] = -sin(gamma);
	matrix[2][2] = cos(gamma);
}