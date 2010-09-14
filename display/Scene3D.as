/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.display {
	import net.badimon.five3D.geom.Point3D;
	
	import flash.display.Sprite;
	import flash.events.Event;	

	/**
	 * The Scene3D class represents an independent 3D scene in which you can create and manipulate 3D objects.
	 * Multiple Scene3D instances can be created in the same SWF file.
	 */
	public class Scene3D extends Sprite {

		private var __viewDistance:Number = 1000;
		private var __ambientLightVector:Point3D;
		private var __ambientLightVectorNormalized:Point3D;
		private var __ambientLightIntensity:Number = .5;

		/**
		 * Creates a new Scene3D instance.
		 * 
		 * @param autoRender	Whether or not the Scene3D instance is automatically rendered on every frame.
		 */
		public function Scene3D(autoRender:Boolean = true) {
			__ambientLightVector = new Point3D(1, 1, 1);
			__ambientLightVectorNormalized = new Point3D(.5773502691896258, .5773502691896258, .5773502691896258);
			if (autoRender) startRender();
		}

		//----------------------------------------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------------------------------------
		/**
		 * The distance between the eye of the viewer and the registration point of the Scene3D instance (the default value is 1000).
		 * This value is used to calculate the perspective transformation. Lower values accentuate the perspective (fisheye effect). 
		 * 
		 * <p>This property has the same behavior than the PerspectiveProjection class <code>focalLength</code> property.</p>
		 */
		public function get viewDistance():Number {
			return __viewDistance;
		}

		public function set viewDistance(value:Number):void {
			__viewDistance = value;
			askRendering();
		}

		/**
		 * Indicates the ambient light vector of the Scene3D instance which determinate the lighting direction.
		 * 
		 * @see #ambientLightVectorNormalized
		 */
		public function get ambientLightVector():Point3D {
			return __ambientLightVector;
		}

		public function set ambientLightVector(value:Point3D):void {
			__ambientLightVector = value;
			__ambientLightVectorNormalized = __ambientLightVector.clone();
			__ambientLightVectorNormalized.normalize(1);
			askRenderingShading();
		}

		/**
		 * Indicates the normalized ambient light vector of the Scene3D instance which determinate the lighting direction.
		 * 
		 * @see #ambientLightVector
		 */
		public function get ambientLightVectorNormalized():Point3D {
			return __ambientLightVectorNormalized;
		}

		/**
		 * Indicates the ambient light intensity.
		 * Lower values represent a lower impact of the lighting settings and higher values a higher impact.
		 */
		public function get ambientLightIntensity():Number {
			return __ambientLightIntensity;
		}

		public function set ambientLightIntensity(value:Number):void {
			__ambientLightIntensity = value;
			askRenderingShading();
		}

		//----------------------------------------------------------------------------------------------------
		// Workflow
		//----------------------------------------------------------------------------------------------------
		/**
		 * Start the rendering of the Scene3D instance on every frame.
		 * 
		 * @see #stopRender()
		 */
		public function startRender():void {
			initializeRendering();
		}

		/**
		 * Stop the rendering of the Scene3D instance on every frame.
		 * 
		 * @see #startRender()
		 */
		public function stopRender():void {
			desinitializeRendering();
		}

		/**
		 * Renders the Scene3D instance immediately whether or not the scene is automatically rendered on every frame.
		 * 
		 * @see #startRender()
		 * @see #stopRender()
		 */
		public function forceRender():void {
			render();
		}

		private function initializeRendering():void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void {
			render();
		}

		private function render():void {
			var num:int = numChildren;
			for (var i:int = 0;i < num; i++) IObject3D(getChildAt(i)).render(this);
		}

		private function desinitializeRendering():void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function askRendering():void {
			var num:int = numChildren;
			for (var i:int = 0;i < num; i++) IObject3D(getChildAt(i)).askRendering();
		}

		private function askRenderingShading():void {
			var num:int = numChildren;
			for (var i:int = 0;i < num; i++) IObject3D(getChildAt(i)).askRenderingShading();
		}

		/**
		 * Dispose the Scene3D instance and stop the automatic rendering of the scene on every frame if necessary. 
		 */
		public function dispose():void {
			desinitializeRendering();
		}
	}
}