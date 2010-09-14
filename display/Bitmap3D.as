/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.display {
	import net.badimon.five3D.geom.Matrix3D;
	import net.badimon.five3D.geom.Point3D;
	import net.badimon.five3D.utils.InternalUtils;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;	

	/**
	 * The Bitmap3D class is the equivalent in the FIVe3D package of the Bitmap class in the Flash package.
	 * 
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/Bitmap.html
	 */
	public class Bitmap3D extends Shape implements IObject3D {

		private var __visible:Boolean = true;
		private var __x:Number = 0;
		private var __y:Number = 0;
		private var __z:Number = 0;
		private var __scaleX:Number = 1;
		private var __scaleY:Number = 1;
		private var __scaleZ:Number = 1;
		private var __rotationX:Number = 0;
		private var __rotationY:Number = 0;
		private var __rotationZ:Number = 0;
		private var __matrix:Matrix3D;
		private var __concatenatedMatrix:Matrix3D;
		private var __bitmapData:BitmapData;
		private var __smoothing:Boolean;
		private var __subdivisionsHorizontal:int;
		private var __subdivisionsVertical:int;
		private var __singleSided:Boolean = false;
		private var __flatShaded:Boolean = false;
		private var __render:Boolean = true;
		private var __renderCulling:Boolean = false;
		private var __renderTessellation:Boolean = true;
		private var __renderProjection:Boolean = true;
		private var __renderBitmap:Boolean = true;
		private var __drawing:Boolean = false;
		private var __renderShading:Boolean = false;
		private var __flatShading:Boolean = false;
		// Calculation
		private var __point1In:Point3D;
		private var __point2In:Point3D;
		private var __point1Out:Point3D;
		private var __point2Out:Point3D;
		private var __normalVector:Point3D;
		private var __normalVectorCalculated:Boolean = false;
		private var __cameraVector:Point3D;
		private var __culling:Boolean = false;
		private var __points:Array;
		private var __triangles:Array;
		private var __width:int;
		private var __height:int;
		private var __matrices:Array;

		/**
		 * Creates a new Bitmap3D instance.
		 * 
		 * @param bitmapData				The BitmapData object being associated with the Bitmap3D instance.
		 * @param smoothing				Whether or not the Bitmap3D instance is smoothed when scaled.
		 * @param subdivisionsHorizontal		The number of horizontal subdivisions of the bitmap into triangles.
		 * @param subdivisionsVertical		The number of vertical subdivisions of the bitmap into triangles.
		 */
		public function Bitmap3D(bitmapData:BitmapData = null, smoothing:Boolean = true, subdivisionsHorizontal:int = 3, subdivisionsVertical:int = 3) {
			__matrix = new Matrix3D();
			__concatenatedMatrix = new Matrix3D();
			__bitmapData = bitmapData;
			__smoothing = smoothing;
			__subdivisionsHorizontal = subdivisionsHorizontal;
			__subdivisionsVertical = subdivisionsVertical;
			initPoints();
		}

		private function initPoints():void {
			__point1In = new Point3D(0, 0, 0);
			__point2In = new Point3D(0, 0, 1);
		}

		//----------------------------------------------------------------------------------------------------
		// Properties (from normal "Bitmap" class)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Whether or not the Bitmap3D instance is visible. When the Bitmap3D instance is not visible, 3D calculation and rendering are not executed.
		 * Any change of this property takes effect the next time the instance is being rendered. 
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>visible</code> property.</p>
		 */
		override public function get visible():Boolean {
			return __visible;
		}

		override public function set visible(value:Boolean):void {
			__visible = value;
		}

		/**
		 * Indicates the x coordinate (in pixels) of the mouse position on the 3D plane defined by the Bitmap3D instance.
		 * 
		 * <p>This property calculation is intensive and requires the same matrix transformations than the <code>mouseY</code> property calculation.
		 * Therefore using <code>mouseXY</code> is faster than <code>mouseX</code> and <code>mouseY</code> separately.</p>
		 * 
		 * @see #mouseXY
		 */
		override public function get mouseX():Number {
			var scene:Scene3D = InternalUtils.getScene(this);
			if (scene == null) {
				return NaN;
			} else {
				return __concatenatedMatrix.getInverseCoordinates(scene.mouseX, scene.mouseY, scene.viewDistance).x;
			}
		}

		/**
		 * Indicates the y coordinate (in pixels) of the mouse position on the 3D plane defined by the Bitmap3D instance.
		 * 
		 * <p>This property calculation is intensive and requires the same matrix transformations than the <code>mouseY</code> property calculation.
		 * Therefore using <code>mouseXY</code> is faster than <code>mouseX</code> and <code>mouseY</code> separately.</p>
		 * 
		 * @see #mouseXY
		 */
		override public function get mouseY():Number {
			var scene:Scene3D = InternalUtils.getScene(this);
			if (scene == null) {
				return NaN;
			} else {
				return __concatenatedMatrix.getInverseCoordinates(scene.mouseX, scene.mouseY, scene.viewDistance).y;
			}
		}

		/**
		 * Indicates the x and y coordinates (in pixels) of the mouse position on the 3D plane defined by the Bitmap3D instance.
		 */
		public function get mouseXY():Point {
			var scene:Scene3D = InternalUtils.getScene(this);
			if (scene == null) {
				return null;
			} else {
				return __concatenatedMatrix.getInverseCoordinates(scene.mouseX, scene.mouseY, scene.viewDistance);
			}
		}

		/**
		 * Indicates the x coordinate along the x-axis of the Bitmap3D instance relative to the local coordinate system of the 3D parent container.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>x</code> property.</p>
		 */
		override public function get x():Number {
			return __x;
		}

		override public function set x(value:Number):void {
			__x = value;
			askRendering();
		}

		/**
		 * Indicates the y coordinate along the y-axis of the Bitmap3D instance relative to the local coordinate system of the 3D parent container.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>y</code> property.</p>
		 */
		override public function get y():Number {
			return __y;
		}

		override public function set y(value:Number):void {
			__y = value;
			askRendering();
		}

		/**
		 * Indicates the z coordinate along the z-axis of the Bitmap3D instance relative to the local coordinate system of the 3D parent container.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>z</code> property.</p>
		 */
		public function get z():Number {
			return __z;
		}

		public function set z(value:Number):void {
			__z = value;
			askRendering();
		}

		/**
		 * Indicates the x-axis scale (percentage) of the Bitmap3D instance from its registration point relative to the local coordinate system of the 3D parent container.
		 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>scaleX</code> property.</p>
		 */
		override public function get scaleX():Number {
			return __scaleX;
		}

		override public function set scaleX(value:Number):void {
			__scaleX = value;
			askRendering();
		}

		/**
		 * Indicates the y-axis scale (percentage) of the Bitmap3D instance from its registration point relative to the local coordinate system of the 3D parent container.
		 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>scaleY</code> property.</p>
		 */
		override public function get scaleY():Number {
			return __scaleY;
		}

		override public function set scaleY(value:Number):void {
			__scaleY = value;
			askRendering();
		}

		/**
		 * Indicates the z-axis scale (percentage) of the Bitmap3D instance from its registration point relative to the local coordinate system of the 3D parent container.
		 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>scaleZ</code> property.</p>
		 */
		public function get scaleZ():Number {
			return __scaleZ;
		}

		public function set scaleZ(value:Number):void {
			__scaleZ = value;
			askRendering();
		}

		/**
		 * Indicates the x-axis rotation (in degrees) of the Bitmap3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
		 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>rotationX</code> property.</p>
		 */
		public function get rotationX():Number {
			return __rotationX;
		}

		public function set rotationX(value:Number):void {
			__rotationX = InternalUtils.formatRotation(value);
			askRendering();
		}

		/**
		 * Indicates the y-axis rotation (in degrees) of the Bitmap3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
		 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>rotationY</code> property.</p>
		 */
		public function get rotationY():Number {
			return __rotationY;
		}

		public function set rotationY(value:Number):void {
			__rotationY = InternalUtils.formatRotation(value);
			askRendering();
		}

		/**
		 * Indicates the z-axis rotation (in degrees) of the Bitmap3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
		 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
		 * 
		 * <p>This property has the same behavior than the normal Bitmap <code>rotationZ</code> property.</p>
		 */
		public function get rotationZ():Number {
			return __rotationZ;
		}

		public function set rotationZ(value:Number):void {
			__rotationZ = InternalUtils.formatRotation(value);
			askRendering();
		}

		/**
		 * Indicates the BitmapData object being associated with the Bitmap3D instance.
		 * 
		 * * <p>This property has the same behavior than the normal Bitmap <code>bitmapData</code> property.</p>
		 */
		public function get bitmapData():BitmapData {
			return __bitmapData;
		}

		public function set bitmapData(value:BitmapData):void {
			__bitmapData = value;
			if (__bitmapData == null) {
				if (__drawing) removeBitmap();
			} else {
				if (__bitmapData.width != __width || __bitmapData.height != __height) {
					__renderTessellation = true;
					__renderProjection = true;
				}
			}
			__renderBitmap = true;
		}

		/**
		 * Whether or not the Bitmap3D instance is smoothed when scaled.
		 * If true, the bitmap is smoothed when scaled. If false, the bitmap is not smoothed when scaled.
		 */
		public function get smoothing():Boolean {
			return __smoothing;
		}

		public function set smoothing(value:Boolean):void {
			__smoothing = value;
			__renderBitmap = true;
		}

		//----------------------------------------------------------------------------------------------------
		// Properties (new)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Indicates a Matrix3D object representing the combined transformation matrixes of the Bitmap3D instance and all of its parent 3D objects, back to the scene level.
		 */
		public function get concatenatedMatrix():Matrix3D {
			return __concatenatedMatrix;
		}

		/**
		 * Indicates the number of horizontal subdivisions of the bitmap into triangles.
		 */
		public function get subdivisionsHorizontal():int {
			return __subdivisionsHorizontal;
		}

		public function set subdivisionsHorizontal(value:int):void {
			__subdivisionsHorizontal = value;
			__renderTessellation = true;
			__renderProjection = true;
			__renderBitmap = true;
		}

		/**
		 * Indicates the number of vertical subdivisions of the bitmap into triangles.
		 */
		public function get subdivisionsVertical():int {
			return __subdivisionsVertical;
		}

		public function set subdivisionsVertical(value:int):void {
			__subdivisionsVertical = value;
			__renderTessellation = true;
			__renderProjection = true;
			__renderBitmap = true;
		}

		/**
		 * Whether or not the Bitmap3D instance is visible when not facing the screen.
		 */
		public function get singleSided():Boolean {
			return __singleSided;
		}

		public function set singleSided(value:Boolean):void {
			__singleSided = value;
			if (__singleSided) {
				__renderCulling = true;
			} else {
				__renderCulling = false;
				__culling = false;
			}
		}

		/**
		 * Whether or not the Bitmap3D instance colors are being altered by the scene ligthing parameters.
		 * 
		 * @see net.badimon.five3D.display.Scene3D.#ambientLightVector
		 * @see net.badimon.five3D.display.Scene3D.#ambientLightIntensity
		 */
		public function get flatShaded():Boolean {
			return __flatShaded;
		}

		public function set flatShaded(value:Boolean):void {
			__flatShaded = value;
			if (__flatShaded) {
				__renderShading = true;
			} else {
				__renderShading = false;
				if (__flatShading) removeFlatShading();
			}
		}

		//----------------------------------------------------------------------------------------------------
		// Workflow
		//----------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public function askRendering():void {
			__render = true;
			if (__singleSided) __renderCulling = true;
			__renderProjection = true;
			__renderBitmap = true;
			if (__flatShaded) __renderShading = true;
		}

		/**
		 * @private
		 */
		public function askRenderingShading():void {
			if (__flatShaded) __renderShading = true;
		}

		/**
		 * @private
		 */
		public function render(scene:Scene3D):void {
			if (!__visible && super.visible) super.visible = false;
			else if (__visible) {
				if (__render) {
					InternalUtils.setMatrix(__matrix, __x, __y, __z, __rotationX, __rotationY, __rotationZ, __scaleX, __scaleY, __scaleZ);
					__concatenatedMatrix = InternalUtils.setConcatenatedMatrix(parent, __matrix);
					__normalVectorCalculated = false;
					__render = false;
				}
				if (__renderCulling) {
					setNormalVector();
					setCulling(scene.viewDistance);
					__normalVectorCalculated = true;
					__renderCulling = false;
				}
				if (__culling) {
					if (super.visible) super.visible = false;
				} else {
					if (!super.visible) super.visible = true;
					if (__bitmapData != null) {
						if (__renderTessellation) {
							setTessellation();
							__renderTessellation = false;
						}
						if (__renderProjection) {
							setProjection(scene.viewDistance);
							__renderProjection = false;
						}
						if (__renderBitmap) {
							drawBitmap();
							__renderBitmap = false;
						}
						if (__renderShading) {
							setNormalVector();
							applyFlatShading(scene);
							__renderShading = false;
						}
					}
				}
			}
		}

		private function setNormalVector():void {
			__point1Out = __concatenatedMatrix.transformPoint(__point1In);
			__point2Out = __concatenatedMatrix.transformPoint(__point2In);
			__normalVector = __point2Out.subtract(__point1Out);
		}

		private function setCulling(viewDistance:Number):void {
			__cameraVector = new Point3D(__point1Out.x, __point1Out.y, __point1Out.z + viewDistance);
			__culling = __normalVector.dot(__cameraVector) < 0;
		}

		private function setTessellation():void {
			__width = __bitmapData.width;
			__height = __bitmapData.height;
			setTessellationPoints();
			setTessellationTriangles();
		}

		private function setTessellationPoints():void {
			__points = [];
			var stepHorizontal:Number = __width / __subdivisionsHorizontal;
			var stepVertical:Number = __height / __subdivisionsVertical;
			var x:Number, y:Number;
			for (var j:int = 0 ;j < __subdivisionsVertical + 1; j++) {
				for (var i:int = 0;i < __subdivisionsHorizontal + 1; i++) {
					x = i * stepHorizontal;
					y = j * stepVertical;
					__points.push({x:x, y:y, xp:x, yp:y});
				}
			}
		}

		private function setTessellationTriangles():void {
			__triangles = [];
			for (var j:int = 0;j < __subdivisionsVertical; j++) {
				for (var i:int = 0;i < __subdivisionsHorizontal; i++) {
					__triangles.push([__points[i + j * (__subdivisionsHorizontal + 1)], __points[i + j * (__subdivisionsHorizontal + 1) + 1], __points[i + (j + 1) * (__subdivisionsHorizontal + 1)]]);
					__triangles.push([__points[i + (j + 1) * (__subdivisionsHorizontal + 1) + 1], __points[i + (j + 1) * (__subdivisionsHorizontal + 1)], __points[i + j * (__subdivisionsHorizontal + 1) + 1]]);
				}
			}
		}

		private function setProjection(viewDistance:Number):void {
			projectPoints(viewDistance);
			setProjectionMatrices();
		}

		private function projectPoints(viewDistance:Number):void {
			var point:Object, pointProjected:Point3D;
			var len:int = __points.length;
			while (--len > -1) {
				point = __points[len];
				pointProjected = __concatenatedMatrix.transformPoint(new Point3D(point["x"], point["y"]));
				pointProjected.project(pointProjected.getPerspective(viewDistance));
				point["xp"] = pointProjected.x;
				point["yp"] = pointProjected.y;
			}
		}

		private function setProjectionMatrices():void {
			__matrices = [];
			var triangle:Array, point1:Object, point2:Object, point3:Object;
			var x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, xp1:Number, yp1:Number, xp2:Number, yp2:Number, xp3:Number, yp3:Number;
			var matrix:Matrix = new Matrix();
			var matrixProjected:Matrix = new Matrix();
			var len:int = __triangles.length;
			while (--len > -1) {
				triangle = __triangles[len];
				point1 = triangle[0];
				point2 = triangle[1];
				point3 = triangle[2];
				x1 = point1["x"];
				y1 = point1["y"];
				x2 = point2["x"];
				y2 = point2["y"];
				x3 = point3["x"];
				y3 = point3["y"];
				xp1 = point1["xp"];
				yp1 = point1["yp"];
				xp2 = point2["xp"];
				yp2 = point2["yp"];
				xp3 = point3["xp"];
				yp3 = point3["yp"];
				matrix.a = x2 - x1;
				matrix.b = y2 - y1;
				matrix.c = x3 - x1;
				matrix.d = y3 - y1;
				matrix.tx = x1;
				matrix.ty = y1;
				matrixProjected.a = xp2 - xp1;
				matrixProjected.b = yp2 - yp1;
				matrixProjected.c = xp3 - xp1;
				matrixProjected.d = yp3 - yp1;
				matrixProjected.tx = xp1;
				matrixProjected.ty = yp1;
				matrix.invert();
				matrix.concat(matrixProjected);
				__matrices.unshift(matrix.clone());
			}
		}

		private function drawBitmap():void {
			var triangle:Array, point1:Object, point2:Object, point3:Object;
			var xp1:Number, yp1:Number, xp2:Number, yp2:Number, xp3:Number, yp3:Number;
			var len:int = __triangles.length;
			super.graphics.clear();
			while (--len > -1) {
				triangle = __triangles[len];
				point1 = triangle[0];
				point2 = triangle[1];
				point3 = triangle[2];
				xp1 = point1["xp"];
				yp1 = point1["yp"];
				xp2 = point2["xp"];
				yp2 = point2["yp"];
				xp3 = point3["xp"];
				yp3 = point3["yp"];
				super.graphics.beginBitmapFill(__bitmapData, __matrices[len], false, __smoothing);
				super.graphics.moveTo(xp1, yp1);
				super.graphics.lineTo(xp2, yp2);
				super.graphics.lineTo(xp3, yp3);
				super.graphics.lineTo(xp1, yp1);
				super.graphics.endFill();
			}
			__drawing = true;
		}

		private function removeBitmap():void {
			super.graphics.clear();
			__drawing = false;
		}

		private function applyFlatShading(scene:Scene3D):void {
			__normalVector.normalize(1);
			InternalUtils.setFlatShading(this, __normalVector, scene.ambientLightVectorNormalized, scene.ambientLightIntensity, alpha);
			__flatShading = true;
		}

		private function removeFlatShading():void {
			transform.colorTransform = new ColorTransform();
			__flatShading = false;
		}

		//----------------------------------------------------------------------------------------------------
		// Errors
		//----------------------------------------------------------------------------------------------------
		/**
		 * @private
		 */
		override public function get height():Number {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set height(value:Number):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get rotation():Number {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set rotation(value:Number):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get scale9Grid():Rectangle {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set scale9Grid(value:Rectangle):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get scrollRect():Rectangle {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set scrollRect(value:Rectangle):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get width():Number {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set width(value:Number):void {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function globalToLocal(point:Point):Point {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function localToGlobal(point:Point):Point {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get graphics():Graphics {
			throw new Error("The Bitmap3D class does not implement this property or method.");
		}
	}
}