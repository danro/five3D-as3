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
	import flash.display.Sprite;
	import flash.geom.Rectangle;	

	/**
	 * The Sprite2D class is the equivalent in the FIVe3D package of the Sprite class in the Flash package but contrary to the Sprite3D class, the Sprite2D class always faces the screen.
	 * 
	 * @see Sprite3D
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/Sprite.html
	 */
	public class Sprite2D extends Sprite implements IObject3D {

		private var __visible:Boolean = true;
		private var __x:Number = 0;
		private var __y:Number = 0;
		private var __z:Number = 0;
		private var __scaleX:Number = 1;
		private var __scaleY:Number = 1;
		private var __matrix:Matrix3D;
		private var __concatenatedMatrix:Matrix3D;
		private var __scaled:Boolean = true;
		private var __render:Boolean = true;
		private var __renderScaling:Boolean = true;
		private var __scaling:Boolean = false;
		// Calculation
		private var __point1In:Point3D;
		private var __point1Out:Point3D;
		private var __perspective:Number;

		/**
		 * Creates a new Sprite2D instance.
		 */
		public function Sprite2D() {
			__matrix = new Matrix3D();
			__concatenatedMatrix = new Matrix3D();
			initPoints();
		}

		private function initPoints():void {
			__point1In = new Point3D(0, 0, 0);
		}

		//----------------------------------------------------------------------------------------------------
		// Properties (from normal "Sprite" class)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Whether or not the Sprite2D instance is visible. When the Sprite2D instance is not visible, 3D calculation and rendering are not executed.
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
		 * Indicates the x coordinate along the x-axis of the Sprite2D instance relative to the local coordinate system of the 3D parent container.
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
		 * Indicates the y coordinate along the y-axis of the Sprite2D instance relative to the local coordinate system of the 3D parent container.
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
		 * Indicates the z coordinate along the z-axis of the Sprite2D instance relative to the local coordinate system of the 3D parent container.
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
		 * Indicates the x-axis scale (percentage) of the Sprite2D instance from its registration point relative or not to the local coordinate system of the 3D parent container depending on the <code>scaled</code> property setting.
		 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>scaleX</code> property.</p>
		 * 
		 * @see #scaled
		 */
		override public function get scaleX():Number {
			return __scaleX;
		}

		override public function set scaleX(value:Number):void {
			__scaleX = value;
			if (__scaled) __renderScaling = true;
			else super.scaleX = __scaleX;
		}

		/**
		 * Indicates the y-axis scale (percentage) of the Sprite2D instance from its registration point relative or not to the local coordinate system of the 3D parent container depending on the <code>scaled</code> property setting.
		 * A value of 0.0 equals a 0% scale and a value of 1.0 equals a 100% scale.
		 * 
		 * <p>This property has the same behavior than the normal Sprite <code>scaleY</code> property.</p>
		 * 
		 * @see #scaled
		 */
		override public function get scaleY():Number {
			return __scaleY;
		}

		override public function set scaleY(value:Number):void {
			__scaleY = value;
			if (__scaled) __renderScaling = true;
			else super.scaleY = __scaleY;
		}

		//----------------------------------------------------------------------------------------------------
		// Properties (new)
		//----------------------------------------------------------------------------------------------------
		/**
		 * A Matrix3D object representing the combined transformation matrixes of the Sprite2D instance and all of its parent 3D objects, back to the scene level.
		 */
		public function get concatenatedMatrix():Matrix3D {
			return __concatenatedMatrix;
		}

		/**
		 * Wether or not the Sprite2D instance scale is being affected by its depth in the 3D scene independently from the <code>scaleX</code> and <code>scaleY</code> properties.
		 */
		public function get scaled():Boolean {
			return __scaled;
		}

		public function set scaled(value:Boolean):void {
			__scaled = value;
			if (__scaled) {
				__renderScaling = true;
			} else {
				__renderScaling = false;
				if (__scaling) removeScaling();
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
			if (__scaled) __renderScaling = true;
		}

		/**
		 * @private
		 */
		public function askRenderingShading():void {
		}

		/**
		 * @private
		 */
		public function render(scene:Scene3D):void {
			if (!__visible && super.visible) super.visible = false;
			else if (__visible) {
				if (!super.visible) super.visible = true;
				if (__render) {
					var viewDistance:Number = scene.viewDistance;
					InternalUtils.setMatrixPosition(__matrix, __x, __y, __z);
					__concatenatedMatrix = InternalUtils.setConcatenatedMatrix(parent, __matrix);
					__point1Out = __concatenatedMatrix.transformPoint(__point1In);
					__perspective = __point1Out.getPerspective(viewDistance);
					setPlacement();
					__render = false;
				}
				if (__renderScaling) {
					applyScaling();
					__renderScaling = false;
				}
			}
		}

		private function setPlacement():void {
			super.x = __point1Out.x * __perspective;
			super.y = __point1Out.y * __perspective;
		}

		private function applyScaling():void {
			super.scaleX = __scaleX * __perspective;
			super.scaleY = __scaleY * __perspective;
			__scaling = true;
		}

		private function removeScaling():void {
			super.scaleX = __scaleX;
			super.scaleY = __scaleY;
			__scaling = false;
		}

		//----------------------------------------------------------------------------------------------------
		// Errors
		//----------------------------------------------------------------------------------------------------
		/**
		 * @private
		 */
		override public function get dropTarget():DisplayObject {
			throw new Error("The Sprite2D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void {
			throw new Error("The Sprite2D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function stopDrag():void {
			throw new Error("The Sprite2D class does not implement this property or method.");
		}
	}
}