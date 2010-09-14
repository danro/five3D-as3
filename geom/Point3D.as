/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.geom {

	/**
	 * The Point3D class is the equivalent in the FIVe3D package of the Point class in the Flash package.
	 * 
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/geom/Point.html
	 */
	public class Point3D {

		public var x:Number;
		public var y:Number;
		public var z:Number;

		/**
		 * Creates a new Point3D instance.
		 * 
		 * @param x				The x coordinate along the x-axis.
		 * @param y				The y coordinate along the y-axis.
		 * @param z				The z coordinate along the z-axis.
		 */
		public function Point3D(x:Number = 0, y:Number = 0, z:Number = 0) {
			this.x = x;
			this.y = y;
			this.z = z;
		}

		/**
		 * The length of the line segment from (0,0) to this Point3D instance.
		 * 
		 * <p>This property has the same behavior than the normal Point <code>length</code> property.</p>
		 */
		public function get length():Number {
			return Math.sqrt(x * x + y * y + z * z);
		}

		/**
		 * Creates a copy of this Point3D instance.
		 * 
		 * <p>This method has the same behavior than the normal Point <code>clone</code> method.</p>
		 */
		public function clone():Point3D {
			return new Point3D(x, y, z);
		}

		/**
		 * Scales the line segment between (0,0) and the current point to a set length.
		 * 
		 * <p>This method has the same behavior than the normal Point <code>normalize</code> method.</p>
		 * 
		 * @param thickness		The scaling value. For example, if the current point is (0,5), and you normalize it to 1, the point returned is at (0,1). 
		 */
		public function normalize(thickness:Number):void {
			var l:Number = length;
			if (l) scale(thickness / l);
			else z = thickness;
		}

		private function scale(s:Number):void {
			x *= s;
			y *= s;
			z *= s;
		}

		/**
		 * Subtracts the coordinates of another Point3D object from the coordinates of this Point3D instance to create a new point.
		 * 
		 * <p>This method has the same behavior than the normal Point <code>subtract</code> method.</p>
		 * 
		 * @param v				The Point object to be subtracted.
		 */
		public function subtract(v:Point3D):Point3D {
			return new Point3D(x - v.x, y - v.y, z - v.z);
		}

		/**
		 * Returns a string listing the properties of the Point3D instance.
		 * 
		 * @return A string containing the properties of the Point3D instance.
		 */
		public function toString():String {
			return "(x=" + x + ", y=" + y + ", z=" + z + ")";
		}

		/**
		 * Return the dot product of the Point3D instance and a specified Point3D object.
		 * 
		 * @return The dot product of the Point3D instance and a specified Point3D object.
		 */
		public function dot(v:Point3D):Number {
			return x * v.x + y * v.y + z * v.z;
		}

		/**
		 * Returns the perspective value of the Point3D instance according to the projection parameter specified.
		 * 
		 * @param viewDistance	The distance between the eye of the viewer and the registration point of a Scene3D instance.
		 * 
		 * @return The perspective value of the Point3D instance.
		 */
		public function getPerspective(viewDistance:Number):Number {
			return viewDistance / (z + viewDistance);
		}

		/**
		 * Projects the Point3D instance from a 3D world to a 2D world according to its perspective value. 
		 * 
		 * @param viewDistance	The distance between the eye of the viewer and the registration point of a Scene3D instance.
		 */
		public function project(perspective:Number):void {
			x *= perspective;
			y *= perspective;
			z = 0;
		}
	}
}