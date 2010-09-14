/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.geom {
	import flash.geom.Point;																																		

	/**
	 * The Matrix3D class is the equivalent in the FIVe3D package of the Matrix class in the Flash package.
	 * 
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/geom/Matrix.html
	 */
	public class Matrix3D {

		public var a:Number;
		public var b:Number;
		public var c:Number;
		public var d:Number;
		public var e:Number;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var i:Number;
		public var tx:Number;
		public var ty:Number;
		public var tz:Number;

		/**
		 * Creates a new Matrix3D instance.
		 */
		public function Matrix3D(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 0, e:Number = 1, f:Number = 0, g:Number = 0, h:Number = 0, i:Number = 1, tx:Number = 0, ty:Number = 0, tz:Number = 0) {
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
			this.e = e;
			this.f = f;
			this.g = g;
			this.h = h;
			this.i = i;
			this.tx = tx;
			this.ty = ty;
			this.tz = tz;
		}

		/**
		 * Creates a copy of this Matrix3D instance.
		 */
		public function clone():Matrix3D {
			return new Matrix3D(a, b, c, d, e, f, g, h, i, tx, ty, tz);
		}

		/**
		 * Concatenates the Matrix3D object specified to the Matrix3D instance, effectively combining the geometric effects of the two.
		 * 
		 * <p>This method has the same behavior than the normal Matrix <code>concat</code> method.</p>
		 * 
		 * @param m			The Matrix3D object to be concatenated to the Matrix3D instance.
		 */
		public function concat(m:Matrix3D):void {
			var values:Object = {};
			values["a"] = a * m.a + b * m.d + c * m.g;
			values["b"] = a * m.b + b * m.e + c * m.h;
			values["c"] = a * m.c + b * m.f + c * m.i;
			values["d"] = d * m.a + e * m.d + f * m.g;
			values["e"] = d * m.b + e * m.e + f * m.h;
			values["f"] = d * m.c + e * m.f + f * m.i;
			values["g"] = g * m.a + h * m.d + i * m.g;
			values["h"] = g * m.b + h * m.e + i * m.h;
			values["i"] = g * m.c + h * m.f + i * m.i;
			values["tx"] = a * m.tx + b * m.ty + c * m.tz + tx;
			values["ty"] = d * m.tx + e * m.ty + f * m.tz + ty;
			values["tz"] = g * m.tx + h * m.ty + i * m.tz + tz;
			initialize(values);
		}

		private function initialize(values:Object):void {
			for (var i:String in values) this[i] = values[i];
		}

		/**
		 * Includes parameters for scaling, rotation, and translation. When applied to a matrix it sets the Matrix3D instance properties based on those parameters.
		 * 
		 * @param scaleX		The x-axis scale (percentage) of the Matrix3D instance.
		 * @param scaleY		The y-axis scale (percentage) of the Matrix3D instance.
		 * @param scaleZ		The z-axis scale (percentage) of the Matrix3D instance.
		 * @param rotationX		The x-axis rotation angle (in radians).
		 * @param rotationY		The y-axis rotation angle (in radians).
		 * @param rotationZ		The z-axis rotation angle (in radians).
		 * @param tx				The x-axis translation along the x-axis (in pixels).
		 * @param ty				The y-axis translation along the y-axis (in pixels).
		 * @param tz				The z-axis translation along the z-axis (in pixels).
		 */
		public function createBox(scaleX:Number, scaleY:Number, scaleZ:Number, rotationX:Number = 0, rotationY:Number = 0, rotationZ:Number = 0, tx:Number = 0, ty:Number = 0, tz:Number = 0):void {
			identity();
			if (rotationX != 0) rotateX(rotationX);
			if (rotationY != 0) rotateY(rotationY);
			if (rotationZ != 0) rotateZ(rotationZ);
			if (scaleX != 1 || scaleY != 1 || scaleZ != 1) scale(scaleX, scaleY, scaleZ);
			if (tx != 0 || ty != 0 || tz != 0) translate(tx, ty, tz);
		}

		/**
		 * Sets each Matrix3D instance property to a value that causes a null transformation. An object transformed by applying an identity matrix will be identical to the original.
		 * 
		 * <p>This method has the same behavior than the normal Matrix <code>identity</code> method.</p>
		 */
		public function identity():void {
			initialize({a:1, b:0, c:0, d:0, e:1, f:0, g:0, h:0, i:1, tx:0, ty:0, tz:0});
		}

		/**
		 * Applies a x-axis rotation (in radians) transformation to the Matrix3D instance.
		 * 
		 * @param angle			The x-axis rotation angle (in radians).
		 */
		public function rotateX(angle:Number):void {
			concat(new Matrix3D(1, 0, 0, 0, Math.cos(angle), -Math.sin(angle), 0, Math.sin(angle), Math.cos(angle), 0, 0, 0));
		}

		/**
		 * Applies a y-axis rotation (in radians) transformation to the Matrix3D instance.
		 * 
		 * @param angle			The y-axis rotation angle (in radians).
		 */
		public function rotateY(angle:Number):void {
			concat(new Matrix3D(Math.cos(angle), 0, Math.sin(angle), 0, 1, 0, -Math.sin(angle), 0, Math.cos(angle), 0, 0, 0));
		}

		/**
		 * Applies a z-axis rotation (in radians) transformation to the Matrix3D instance.
		 * 
		 * @param angle			The z-axis rotation angle (in radians).
		 */
		public function rotateZ(angle:Number):void {
			concat(new Matrix3D(Math.cos(angle), -Math.sin(angle), 0, Math.sin(angle), Math.cos(angle), 0, 0, 0, 1, 0, 0, 0));
		}

		/**
		 * Applies a scaling transformation along the three axis to the Matrix3D instance.
		 * 
		 * @param sx			The x-axis scale (percentage) of the Matrix3D instance.
		 * @param sy			The y-axis scale (percentage) of the Matrix3D instance.
		 * @param sz			The z-axis scale (percentage) of the Matrix3D instance.
		 */
		public function scale(sx:Number, sy:Number, sz:Number):void {
			concat(new Matrix3D(sx, 0, 0, 0, sy, 0, 0, 0, sz, 0, 0, 0));
		}

		/**
		 * Returns a string listing the properties of the Matrix3D instance.
		 * 
		 * @return A string containing the properties of the Matrix3D instance.
		 */
		public function toString():String {
			return "(a=" + a + ", b=" + b + ", c=" + c + ", d=" + d + ", e=" + e + ", f=" + f + ", g=" + g + ", h=" + h + ", i=" + i + ", tx=" + tx + ", ty=" + ty + ", tz=" + tz + ")";
		}

		/**
		 * Returns the result of applying the geometric transformation represented by the Matrix3D instance to the specified point.
		 * 
		 * <p>This method has the same behavior than the normal Matrix <code>transformPoint</code> method.</p>
		 * 
		 * @param point			The point for which you want to get the result of the Matrix transformation.
		 * 
		 * @return The Point object resulting from applying the Matrix3D instance transformation.
		 */
		public function transformPoint(point:Point3D):Point3D {
			return new Point3D(a * point.x + b * point.y + c * point.z + tx, d * point.x + e * point.y + f * point.z + ty, g * point.x + h * point.y + i * point.z + tz);
		}

		/**
		 * Applies a translation transformation along the three axis to the Matrix3D instance.
		 * 
		 * @param dx			The x-axis translation along the x-axis (in pixels). 
		 * @param dy			The y-axis translation along the y-axis (in pixels).
		 * @param dz			The z-axis translation along the z-axis (in pixels).
		 */
		public function translate(dx:Number, dy:Number, dz:Number):void {
			tx += dx;
			ty += dy;
			tz += dz;
		}

		/**
		 * Returns the x and y coordinates (in pixels) on the 3D plane represented by the Matrix3D instance of the x and y coordinates projected on the screen.
		 * 
		 * @param x				The projected x coordinate along the x-axis. 
		 * @param y				The projected y coordinate along the y-axis.
		 * @param viewDistance	The distance between the eye of the viewer and the registration point of a Scene3D instance.
		 * 
		 * @return A Point object containing the inverse coordinates.
		 */
		public function getInverseCoordinates(x:Number, y:Number, viewDistance:Number):Point {
			var m:Array = [a, b, c, tx, d, e, f, ty, 0, 0, 1, 0, g / viewDistance, h / viewDistance, i / viewDistance, tz / viewDistance + 1];
			var m2:Array = invertTraditional(m);
			var w:Number = m2[12] * x + m2[13] * y + m2[15];
			return new Point((m2[0] * x + m2[1] * y + m2[3]) / w, (m2[4] * x + m2[5] * y + m2[7]) / w);
		}

		private function invertTraditional(m:Array):Array {
			var m2:Array = [];
			var determinant:Number = getDeterminant4(m);
			for (var k:int = 0;k < 4; k++) for (var j:int = 0;j < 4; j++) m2[j * 4 + k] = getDeterminant3(extractMatrix3(m, j, k)) * (1 - ((j + k) % 2) * 2) / determinant;
			return m2;
		}

		private function getDeterminant4(m:Array):Number {
			return m[0] * getDeterminant3(extractMatrix3(m, 0, 0)) - m[1] * getDeterminant3(extractMatrix3(m, 1, 0)) + m[2] * getDeterminant3(extractMatrix3(m, 2, 0)) - m[3] * getDeterminant3(extractMatrix3(m, 3, 0));
		}

		private function extractMatrix3(m:Array, index1:Number, index2:Number):Array {
			var m2:Array = [];
			for (var k:int = 0;k < 4; k++) if (k != index2) for (var j:int = 0;j < 4; j++) if (j != index1) m2.push(m[j + k * 4]);
			return m2;
		}

		private function getDeterminant3(m:Array):Number {
			return m[0] * (m[4] * m[8] - m[7] * m[5]) - m[1] * (m[3] * m[8] - m[6] * m[5]) + m[2] * (m[3] * m[7] - m[6] * m[4]);
		}
	}
}