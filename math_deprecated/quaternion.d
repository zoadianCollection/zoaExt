/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 */
module ext.math.quaternion;

import ext.math.vector;
import ext.math.matrix;
import ext.math.angle;

///
struct Quaternion(T = float)
{
private:
	union
	{
		T[4] _quat = [0,0,0,1];
		struct
		{
			T x, y, z, w;
		}
	}

public:
	///
    this(T x, T y, T z, T w)
	{
		this._quat = [x,y,z,w];
	}

	///
	this(in Vector!(4,T) vec)
	{
		this._quat = vec.xyzw;
	}

	///
	this(in Radian rfAngle, in Vector!(3,T) rkAxis)
	{
		Radian halfAngle = Radian(0.5*rfAngle);
		real fSin = sin(halfAngle);
		this._quat = [fsin*rkAxis.x, fsin*rkAxis.y, fsin*rkAxis.z, cos(halfAngle)];
	}

	/// Returns: Identity Quaternion(0,0,0,1)
    static @property Quaternion identity() 
	{
        return Quaternion(0, 0, 0, 1);
    }

	/// Makes the current quaternion an identity quaternion.
    void makeIdentity() 
	{
        this.x = 0;
        this.y = 0;
        this.z = 0;
        this.w = 1;
    }

    //this(in Vector!(3,T) xAxis, in Vector!(3,T) yAxis, in Vector!(3,T) zAxis)
    //this(in Matrix!(3,3,T) rot)
public:
    //void swap(inout Quaternion q)

	///
    T opIndex(size_t i)
	{
		return this.v[i];
	}

	///
    T opIndexAssign(T value, size_t i)
	{
		return this.v[i] = value;
	}

	///
    @property auto ptr()
	{
		return this.v.ptr;
	}

	///
    @property Vector!(3,T) xAxis() const
	{
		//real Tx = 2.0f*this.x;
		real ty = 2.0f*this.y;
		real tz = 2.0f*this.z;
		real twy = ty*this.w;
		real twz = tz*this.w;
		real txy = ty*this.x;
		real txz = tz*this.x;
		real tyy = ty*this.y;
		real tzz = tz*this.z;
		return Vector!(3,T)(1.0f-(tyy+tzz), txy+twx, txz-twy);
	}

	///
    @property Vector!(3,T) yAxis() const
	{
		real Tx = 2.0f*this.x;
		real ty = 2.0f*this.y;
		real tz = 2.0f*this.z;
		real twy = ty*this.w;
		real twz = tz*this.w;
		real txy = ty*this.x;
		real txz = tz*this.x;
		real tyy = ty*this.y;
		real tzz = tz*this.z;
		return Vector!(3,T)(txy-twz, 1.0f-(txx-tzz), tyz+twx);
	}

	///
    @property Vector!(3,T) zAxis() const
	{
		real Tx = 2.0f*this.x;
		real ty = 2.0f*this.y;
		real tz = 2.0f*this.z;
		real twy = ty*this.w;
		real twz = tz*this.w;
		real txy = ty*this.x;
		real txz = tz*this.x;
		real tyy = ty*this.y;
		real tzz = tz*this.z;
		return Vector!(3,T)(txz+twy, tyz-twx, 1.0f-(txx+tyy));
	}
public:
	///
    inout Quaternion opAssign(in Quaternion q)
	{
		this._quat = q._quat;
		return this;
	}

	/// +
	void opOpAssign(string op)(in Quaternion q) 
	if(op == "*")
	{
        T x2 =  this.x*q.w + this.y*q.z - this.z*q.y + this.w*q.x;
        T y2 = -this.x*q.z + this.y*q.w + this.z*q.x + this.w*q.y;
        T z2 =  this.x*q.y - this.y*q.x + this.z*q.w + this.w*q.z;
        T w2 = -this.x*q.x - this.y*q.y - this.z*q.z + this.w*q.w;
		this.x = x2;
		this.y = y2;
		this.z = z2;
		this.w = w2;
    }

	/// + -
	void opOpAssign(string op)(in Quaternion q) 
	if((op == "+") || (op == "-")) 
	{
        mixin("this.x " ~ op ~ "= q.x;");
        mixin("this.y " ~ op ~ "= q.y;");
        mixin("this.z " ~ op ~ "= q.z;");
        mixin("this.w " ~ op ~ "= q.w;");
    }

	/// *
	void opOpAssign(string op)(T t) 
	if(op == "*")
	{
        this.x *= t;
        this.y *= t;
        this.z *= t;
        this.w *= t;
    }

	/// + -
    Quaternion opBinary(string op)(in Quaternion q) const 
	if(op == "+" || op== "-")
	{
		mixin("return Quaternion(this.x"~op~"q.x, this.y"~op~"q.y, this.z"~op~"q.z, this.w"~op~"q.w);");
	}

	/**
	* NOTE:  Multiplication is not generally commutative, so in most
	* cases p*q != q*p.
	*/
	Quaternion opBinary(string op)(in Quaternion q) const 
	if(op == "*")
	{
		return Quaternion(
			this.w * q.x + x * q.w + y * q.z - z * q.y,
			this.w * q.y + y * q.w + z * q.x - x * q.z,
			this.w * q.z + z * q.w + x * q.y - y * q.x,
			this.w * q.w - x * q.x - y * q.y - z * q.z
		);
	}

	/// *
    Quaternion opBinary(string op)(real scalar) const 
	if(op == "*")
	{
		mixin("return Quaternion(scalar"~op~"this.x, scalar"~op~"this.y, scalar"~op~"this.z, scalar"~op~"this.w);");
	}


	/// -
    Quaternion opUnary(string op)() const 
	if (op == "-")
	{
		return Quaternion(-x, -y, -z, -w);
	}

	///
	const bool opEquals(ref const Quaternion q) {
        return this._quat == q._quat;
    }

	///
	T dotProduct(in Quaternion q) const
	{
		return this.x*q.x + this.y*q.y + this.z*q.z + this.w*q.w ;
	}

	///
    @property T length2() const
	{
		return this.x^^2 + this.y^^2 + this.z^^2 + this.w^^2;
	}
	
	///
    @property T length() const
	{
		return sqrt(this.x^^2 + this.y^^2 + this.z^^2 + this.w^^2);
	}

	///
    void normalise()
	{
		assert(this.length != 0);
		real len = this.length;
		real factor = 1.0f / len;
		
		if(len == 0)
			return;

		this.x *= factor;
		this.y *= factor;
		this.z *= factor;
		this.w *= factor;
	}

	///
	Quaternion normalisedCopy() 
	{
		assert(this.length != 0);
		real len = this.length;
		real factor = 1.0f / len;

		if(len == 0)
			return Quaternion(this.x, this.y, this.z, this.w);

        Quaternion ret;
        ret.w = this.w * factor;
        ret.x = this.x * factor;
        ret.y = this.y * factor;
        ret.z = this.z * factor;
        return ret;
    }

	///
    Quaternion inverse() const
	{
		real norm = norm();
		if(norm > 0.0f)
		{
			real invNorm = 1.0f/norm;
			return Quaternion(-this.x*invNorm, -this.y*invNorm, -this.z*invNorm, this.w*invNorm);
		}
		else
		{
			return Quaternion(0,0,0,0);
		}
	}

	///
    Quaternion unitInverse() const
	{
		return Quaternion(-x, -y, -z, w);
	}


	//Quaternion exp() const
	//{
	//    Radian angle = Radian(sqrt(this.x*this.x+this.y*this.y+this.z*this.z));
	//    real sin = sin(angle);
	//    if(abs(sin) >= 
	//}


    //Quaternion log() const

	/// *
    Vector!(3,T) opBinary(string op)(in Vector!(3,T) rkVector) const
	if(op == "*")
	{
		Vector!(3,T) uv;
		Vector!(3,T) uuv;
		Vector!(3,T) qvec = Vector!(3,T)(this.x, this.y, this.z);
		uv = qvec.crossProduct(rkVector);
		uuv = qvec.crossProduct(uv);
		uv *= (2.0f*this.w);
		uuv *= 2.0f;
		return v+uv+uuv;
	}

	///
	@property Radian roll()
	{
		return atan2(to!real(2 * (this.w*this.z + this.x*this.y)), to!real(this.w^^2 - this.x^^2 + this.y^^2 - this.z^^2));
	}

	///
	@property Radian pitch()
	{
		return asin(to!real(2 * (w*x - y*z)));
	}
	
	///
	@property Radian yaw()
	{
		return atan2(to!real(2 * (this.w*this.y + this.x*this.z)), to!real(this.w^^2 - this.x^^2 - this.y^^2 + this.z^^2));
	}
    
    //equals with tolerance
    //bool isNaN() const
//public:
//    static Quaternion slerp(T t, ref const Quaternion rkP, ref const Quaternion rkQ, bool shortestPath=false)
//    static Quaternion slerpExtraSpins(T t, ref const Quaternion rkP, ref const Quaternion rkQ, int extraSpins)
//    static void intermediate(ref const Quaternion rkQ0, ref const Quaternion rkQ1, ref const Quaternion rkQ2, ref Quaternion rkA, ref Quaternion rkB)
//    static Quaternion squad(T t, ref const Quaternion rkP, ref const Quaternion rkA, ref const Quaternion rkB, ref const Quaternion rkQ, bool shortestPath=false)
//    static Quaternion nlerp(T t, ref const Quaternion rkP, ref const Quaternion rkQ, bool shortestPath=false)
//    
    
}