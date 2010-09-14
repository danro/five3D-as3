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
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;	

	/**
	 * The Sprite3D class is the equivalent in the FIVe3D package of the Sprite class in the Flash package.
	 * 
	 * @see Sprite2D
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/Sprite.html
	 */
	public class Sprite3D extends Sprite implements IObject3D {

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
		private var __graphics:Graphics3D;
		private var __singleSided:Boolean = false;
		private var __flatShaded:Boolean = false;
		private var __childrenSorted:Boolean = false;
		private var __render:Boolean = true;
		private var __renderCulling:Boolean = false;
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

		/**
		 * Creates a new Sprite3D instance.
		 */
		public function Sprite3D() {
			__matrix = new Matrix3D();
			__concatenatedMatrix = new Matrix3D();
			__graphics = new Graphics3D();
			initPoints();
		}

		private function initPoints():void {
			__point1In = new Point3D(0, 0, 0);
			__point2In = new Point3D(0, 0, 1);
		}

		//----------------------------------------------------------------------------------------------------
		// Properties (from normal "Sprite" class)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Whether or not the Sprite3D instance is visible. When the Sprite3D instance is not visible, 3D calculation and rendering are not executed.
		 * Any change of this property takes effect the next time the instance is being rendered. 
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>visible</code> property.</p>
		 */
		override public function get visible():Boolean {
			return __visible;
		}

		override public function set visible(value:Boolean):void {
			__visible = value;
		}

		/**
		 * Indicates the x coordinate (in pixels) of the mouse position on the 3D plane defined by the Sprite3D instance.
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
		 * Indicates the y coordinate (in pixels) of the mouse position on the 3D plane defined by the Sprite3D instance.
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
		 * Indicates the x and y coordinates (in pixels) of the mouse position on the 3D plane defined by the Sprite3D instance.
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
		 * Indicates the x coordinate along the x-axis of the Sprite3D instance relative to the local coordinate system of the 3D parent container.
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>x</code> property.</p>
		 */
		override public function get x():Number {
			return __x;
		}

		override public function set x(value:Number):void {
			__x = value;
			askRendering();
		}

		/**
		 * Indicates the y coordinate along the y-axis of the Sprite3D instance relative to the local coordinate system of the 3D parent container.
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>y</code> property.</p>
		 */
		override public function get y():Number {
			return __y;
		}

		override public function set y(value:Number):void {
			__y = value;
			askRendering();
		}

		/**
		 * Indicates the z coordinate along the z-axis of the Sprite3D instance relative to the local coordinate system of the 3D parent container.
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>z</code> property.</p>
		 */
		public function get z():Number {
			return __z;
		}

		public function set z(value:Number):void {
			__z = value;
			askRendering();
		}

		/**
		 * Indicates the x-axis scale (percentage) of the Sprite3D instance from its registration point relative to the local coordinate system of the 3D parent container.
		 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>scaleX</code> property.</p>
		 */
		override public function get scaleX():Number {
			return __scaleX;
		}

		override public function set scaleX(value:Number):void {
			__scaleX = value;
			askRendering();
		}

		/**
		 * Indicates the y-axis scale (percentage) of the Sprite3D instance from its registration point relative to the local coordinate system of the 3D parent container.
		 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>scaleY</code> property.</p>
		 */
		override public function get scaleY():Number {
			return __scaleY;
		}

		override public function set scaleY(value:Number):void {
			__scaleY = value;
			askRendering();
		}

		/**
		 * Indicates the z-axis scale (percentage) of the Sprite3D instance from its registration point relative to the local coordinate system of the 3D parent container.
		 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>scaleZ</code> property.</p>
		 */
		public function get scaleZ():Number {
			return __scaleZ;
		}

		public function set scaleZ(value:Number):void {
			__scaleZ = value;
			askRendering();
		}

		/**
		 * Indicates the x-axis rotation (in degrees) of the Sprite3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
		 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>rotationX</code> property.</p>
		 */
		public function get rotationX():Number {
			return __rotationX;
		}

		public function set rotationX(value:Number):void {
			__rotationX = InternalUtils.formatRotation(value);
			askRendering();
		}

		/**
		 * Indicates the y-axis rotation (in degrees) of the Sprite3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
		 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>rotationY</code> property.</p>
		 */
		public function get rotationY():Number {
			return __rotationY;
		}

		public function set rotationY(value:Number):void {
			__rotationY = InternalUtils.formatRotation(value);
			askRendering();
		}

		/**
		 * Indicates the z-axis rotation (in degrees) of the Sprite3D instance from its original orientation relative to the local coordinate system of the 3D parent container.
		 * Values go from -180 (included) to 180 (included). Values outside this range will be formated to fit in.
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>rotationZ</code> property.</p>
		 */
		public function get rotationZ():Number {
			return __rotationZ;
		}

		public function set rotationZ(value:Number):void {
			__rotationZ = InternalUtils.formatRotation(value);
			askRendering();
		}

		//----------------------------------------------------------------------------------------------------
		// Properties (new)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Indicates a Matrix3D object representing the combined transformation matrixes of the Sprite3D instance and all of its parent 3D objects, back to the scene level.
		 */
		public function get concatenatedMatrix():Matrix3D {
			return __concatenatedMatrix;
		}

		/**
		 * Specifies the Graphics3D object that belongs to this Sprite3D instance where vector drawing commands can occur.
		 * 
		 * <p>This property replaces the normal Sprite <code>graphics</code> property. The access to the normal Sprite <code>graphics</code> property throws an error.</p>
		 */
		public function get graphics3D():Graphics3D {
			return __graphics;
		}

		/**
		 * Whether or not the Sprite3D instance is visible when not facing the screen.
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
		 * Whether or not the Sprite3D instance colors are being altered by the scene ligthing parameters.
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

		/**
		 * Whether or not the Sprite3D instance will sort its direct children according to their respective depths. The depth of each child is determined by the z coordinate of its registration point.
		 */
		public function get childrenSorted():Boolean {
			return __childrenSorted;
		}

		public function set childrenSorted(value:Boolean):void {
			__childrenSorted = value;
		}

		//----------------------------------------------------------------------------------------------------
		// Workflow
		//----------------------------------------------------------------------------------------------------
		/**
		 * @private
		 */
		public function askRendering():void {
			__render = true;
			__graphics.askRendering();
			if (__singleSided) __renderCulling = true;
			if (__flatShaded) __renderShading = true;
			var num:int = numChildren;
			for (var i:int = 0;i < num; i++) IObject3D(getChildAt(i)).askRendering();
		}

		/**
		 * @private
		 */
		public function askRenderingShading():void {
			if (__flatShaded) __renderShading = true;
			var num:int = numChildren;
			for (var i:int = 0;i < num; i++) IObject3D(getChildAt(i)).askRenderingShading();
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
					__graphics.render(super.graphics, __concatenatedMatrix, scene.viewDistance);
					if (__renderShading) {
						setNormalVector();
						applyFlatShading(scene);
						__renderShading = false;
					}
					var num:int = numChildren;
					for (var i:int = 0;i < num; i++) IObject3D(getChildAt(i)).render(scene);
					if (__childrenSorted) sortChildren();
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

		private function applyFlatShading(scene:Scene3D):void {
			__normalVector.normalize(1);
			InternalUtils.setFlatShading(this, __normalVector, scene.ambientLightVectorNormalized, scene.ambientLightIntensity, alpha);
			__flatShading = true;
		}

		private function removeFlatShading():void {
			transform.colorTransform = new ColorTransform();
			__flatShading = false;
		}

		private function sortChildren():void {
			var child:IObject3D, sort:Array = [];
			var num:int = numChildren;
			for (var i:int = 0;i < num; i++) {
				child = getChildAt(i) as IObject3D;
				sort.push({child:child, z:child.concatenatedMatrix.tz});
			}
			sort.sortOn("z", Array.DESCENDING | Array.NUMERIC);
			for (i = 0;i < num; i++) setChildIndex(sort[i].child, i);
		}

		//----------------------------------------------------------------------------------------------------
		// Errors
		//----------------------------------------------------------------------------------------------------
		/**
		 * @private
		 */
		override public function get height():Number {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set height(value:Number):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get rotation():Number {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set rotation(value:Number):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get scale9Grid():Rectangle {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set scale9Grid(value:Rectangle):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get scrollRect():Rectangle {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set scrollRect(value:Rectangle):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get width():Number {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set width(value:Number):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function globalToLocal(point:Point):Point {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function localToGlobal(point:Point):Point {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get dropTarget():DisplayObject {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function get graphics():Graphics {
			throw new Error("The Sprite3D class does not implement this property or method (use \"graphics3D\" instead).");
		}

		/**
		 * @private
		 */
		override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function stopDrag():void {
			throw new Error("The Sprite3D class does not implement this property or method.");
		}
	}
}