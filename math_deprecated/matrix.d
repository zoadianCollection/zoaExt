/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 */
module ext.math.matrix;

///MxN-Matrix (m Rows ; n Cols)
struct Matrix(int ROWS, int COLS, T) if (ROWS > 1 && COLS > 1)
{
    static const int rows = ROWS;
    static const int cols = COLS;
    
    T[cols][rows] _mat;
    alias _mat this;

public:
	///
	this(Matrix m)
	{
		this._mat = m._mat;
	}

    ///
    Matrix opBinary(string op)(in Matrix mat)
	if(op == "+" || op == "-")
    {
        Matrix mat = Matrix(this);
        foreach(r; 0..rows)
        {
            foreach(c; 0..cols)
            {
                mixin("m[c][r] "~op~"= mat[c][r];");
            }
        }
    }
    
    ///
    Matrix opBinary(string op)(in T scalar)
	if(op == "*" || op == "/")
    {
        Matrix m = Matrix(this);
        foreach(r; 0..rows)
        {
            foreach(c; 0..cols)
            {
                mixin("m[c][r] "~op~"= scalar;");
            }
        }
    }
    
    ///
    Matrix opBinary(string op)(in Matrix mat)
	if(op == "*")
	{}
    //op^

	///reduced echelon form method
    Matrix inverse()
	{}
	///
    Matrix transpose()
	{}
	///
	Matrix covariant()
	{}
	///
	Matrix normalise()
	{}
	///
    Matrix negate()
	{}
	///
	static if(rows==cols)
	{
		T determinant()
		{}
	}
    ///
	static bool isSquare(){return rows==cols;}
	///
    bool isIdendity()
	{}
	///
    bool isUniformScale()
	{}
    ///
    Matrix transformAffine(in Matrix mat);
    ///
    @property auto ptr()
    {
        return this._mat.ptr;
    }
    ///
    void clear(in T value)
    {
        foreach(r; 0..rows)
        {
            foreach(c; 0..cols)
            {
                this._mat[c,r] = value;
            }
        }
    }
}
