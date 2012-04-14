/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * License: http://www.boost.org/LICENSE_1_0.txt
 */
module ext.container.tree;

import std.algorithm;

/**
 * Implements an element that can be used in a tree, with parents and children.
 * This is probably/maybe threadsafe.
 * Example:
 * --------------------------------
 * class Node 
 * {
 *   mixin Tree!Node;
 * }
 * auto n = new Node();
 * auto n2 = n.add(new Node());
 * -------------------------------- 
 */
mixin template Tree(T)
{       
protected:
	T _parent;                     // reference to parent
	T[] _children;         // array of this element's children.

public:	
	/**
	* Add a child element.
	* Automatically detaches it from any other element's children.
	* Params:
	*     child = Node to add as a child of this element.
	* Returns: A reference to the child. 
	*/
	S add(S : T)(S child)
	{       
		synchronized(this)
		{       
			assert(child !is null);
			assert(child != this);

			// If child has an existing parent.
			if (child.parent)
			{       
				assert(child._parent.isChild(cast(S)child));
				child._parent._children = std.algorithm.find!((T x)=>{return x !is child;})(child._parent._children);
			}

			// Add as a child.
			child._parent = cast(T)this;
			this._children ~= cast(T)child;
		}
		return child;
	}

	/**
	* Remove a child element
	* Params:
	*     child = An element of type T or that inherits from type T.
	* Returns: The child element.  For convenience, the return type is templated to match the input type.
	*/
	S remove(S : T)(S child)
	{       
		synchronized (this)
		{
			assert(child !is null);
			assert(this.isChild(child));
			assert(child._parent == this);
                        
			this._children = std.algorithm.find!((T x)=>{return x !is child;})(this._children);
			child._parent = null;
						
			assert (!isChild(child));
		}
		return child;
	}

	///
	void removeAllChildren()
	{
		synchronized(this)
		{
			foreach(child; this._children)
			{
				this.remove(child);
			}
		}
	}
        
	/// Get an array of this element's children.
	@property ref const(T[]) children()
	{       
		return this._children;
	}
        
	/**
	* Get / set the parent of this element (what it's attached to).
	* Setting a new parent removes it from its old parent's children and returns a self-reference. 
	*/
	@property T parent()
	{       
		return this._parent;
	}
	
	///
	int countChildren() const
	{
		return this._children.length;
	}

	/**
	* Is elem a child of this element?
	* This function will also return false if elem is null. 
	*/ 
	bool isChild(T elem) const
	{       
		synchronized (this)
		{       
			return std.algorithm.countUntil(this._children, elem) != -1;
		}
	}
	
	///
	bool has(T elem) const
	{
		foreach(e; this._children)
		{
			if(e is elem || e.has(elem))
			{
				return true;
			}
		}
		return false;
	}

+++/
}
