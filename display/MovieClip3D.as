package net.badimon.five3D.display {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;	

	/**
	 * The MovieClip3D class is the equivalent in the FIVe3D package of the MovieClip class in the Flash package.
	 * 
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html
	 */
	public class MovieClip3D extends Sprite3D {

		private var __clip:MovieClip;
		private var __clippingRectangle:Rectangle;
		private var __bitmap:Bitmap3D;

		/**
		 * Creates a new MovieClip3D instance.
		 * 
		 * @param clip					The MovieClip object being associated with the MovieClip3D instance.
		 * @param clippingRectangle		A Rectangle object that defines the area of the source object to draw.
		 * @param smoothing			Whether or not the bitmap on which the MovieClip object associated is drawn is smoothed when scaled.
		 */
		public function MovieClip3D(clip:MovieClip, clippingRectangle:Rectangle = null, smoothing:Boolean = true) {
			__clip = clip;
			__clippingRectangle = clippingRectangle;
			createBitmap(smoothing);
		}

		private function createBitmap(smoothing:Boolean):void {
			__bitmap = new Bitmap3D(null, smoothing);
			addChild(__bitmap);
		}

		//----------------------------------------------------------------------------------------------------
		// Properties (from normal "MovieClip" class)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Indicates the number of the frame in which the playhead is located in the timeline of the MovieClip3D instance.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>currentFrame</code> property.</p>
		 */
		public function get currentFrame():int {
			return __clip.currentFrame;
		}

		/**
		 * Indicates the current label in which the playhead is located in the timeline of the MovieClip3D instance.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>currentLabel</code> property.</p>
		 */
		public function get currentLabel():String {
			return __clip.currentLabel;
		}

		/**
		 * Indicates an array of FrameLabel objects from the current scene of the MovieClip3D instance.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>currentLabels</code> property.</p>
		 */
		public function get currentLabels():Array {
			return __clip.currentLabels;
		}

		/**
		 * Indicates the current scene in which the playhead is located in the timeline of the MovieClip3D instance.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>currentScene</code> property.</p>
		 */
		public function get currentScene():Scene {
			return __clip.currentScene;
		}

		/**
		 * Indicates whether the MovieClip3D instance is enabled.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>enabled</code> property.</p>
		 */
		public function get enabled():Boolean {
			return __clip.enabled;
		}

		public function set enabled(value:Boolean):void {
			__clip.enabled = value;
		}

		/**
		 * Indicates the number of frames of the MovieClip3D instance that are loaded from a streaming SWF file.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>framesLoaded</code> property.</p>
		 */
		public function get framesLoaded():int {
			return __clip.framesLoaded;
		}

		/**
		 * Indicates an array of Scene objects of the MovieClip3D instance.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>scenes</code> property.</p>
		 */
		public function get scenes():Array {
			return __clip.scenes;
		}

		/**
		 * Indicates the total number of frames of the MovieClip3D instance.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>totalFrames</code> property.</p>
		 */
		public function get totalFrames():int {
			return __clip.totalFrames;
		}

		/**
		 * Indicates whether or not other display objects can receive mouse release events.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>trackAsMenu</code> property.</p>
		 */
		public function get trackAsMenu():Boolean {
			return __clip.trackAsMenu;
		}

		public function set trackAsMenu(value:Boolean):void {
			__clip.trackAsMenu = value;
		}

		//----------------------------------------------------------------------------------------------------
		// Methods (from normal "MovieClip" class)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Starts playing the MovieClip3D instance at the specified frame.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>gotoAndPlay</code> property.</p>
		 */
		public function gotoAndPlay(frame:Object, scene:String = null):void {
			__clip.gotoAndPlay(frame, scene);
		}

		/**
		 * Brings the playhead to the specified frame of the MovieClip3D instance and stops it there.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>gotoAndStop</code> property.</p>
		 */
		public function gotoAndStop(frame:Object, scene:String = null):void {
			__clip.gotoAndStop(frame, scene);
		}

		/**
		 * Sends the playhead to the next frame of the MovieClip3D instance and stops it there.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>nextFrame</code> property.</p>
		 */
		public function nextFrame():void {
			__clip.nextFrame();
		}

		/**
		 * Moves the playhead to the next scene of the MovieClip3D instance.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>nextScene</code> property.</p>
		 */
		public function nextScene():void {
			__clip.nextScene();
		}

		/**
		 * Starts playing the MovieClip3D instance.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>play</code> property.</p>
		 */
		public function play():void {
			__clip.play();
		}

		/**
		 * Sends the playhead to the previous frame of the MovieClip3D instance and stops it there.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>prevFrame</code> property.</p>
		 */
		public function prevFrame():void {
			__clip.prevFrame();
		}

		/**
		 * Moves the playhead to the previous scene of the MovieClip instance.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>prevScene</code> property.</p>
		 */
		public function prevScene():void {
			__clip.prevScene();
		}

		/**
		 * Stops playing the MovieClip3D instance.
		 * 
		 * <p>This property has the same behavior than the normal MovieClip <code>stop</code> property.</p>
		 */
		public function stop():void {
			__clip.stop();
		}

		//----------------------------------------------------------------------------------------------------
		// Properties (new)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Indicates the MovieClip object being associated with the MovieClip3D instance. 
		 */
		public function get clip():MovieClip {
			return __clip;
		}

		public function set clip(clip:MovieClip):void {
			__clip = clip;
		}

		/**
		 * Indicates a Rectangle object that defines the area of the source object to draw.
		 * If null, no clipping occurs and the entire source object is drawn.
		 */
		public function get clippingRectangle():Rectangle {
			return __clippingRectangle;
		}

		public function set clippingRectangle(clipping:Rectangle):void {
			__clippingRectangle = clipping;
		}

		/**
		 * Whether or not the bitmap on which the MovieClip object associated is drawn is smoothed when scaled.
		 */
		public function get smoothing():Boolean {
			return __bitmap.smoothing;
		}

		public function set smoothing(value:Boolean):void {
			__bitmap.smoothing = value;
		}

		//----------------------------------------------------------------------------------------------------
		// Methods (new)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Activate the rendering of the MovieClip3D instance on every frame.
		 * A call to this method is necessary in order to display the content of the MovieClip object associated.
		 * 
		 * @see #deactivate()
		 */
		public function activate():void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void {
			var bounds:Rectangle = (__clippingRectangle == null) ? __clip.getBounds(__clip) : __clippingRectangle;
			if (bounds.width != 0 && bounds.height != 0) {
				__bitmap.x = bounds.x;
				__bitmap.y = bounds.y;
				var bitmapData:BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00000000);
				var matrix:Matrix = new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y);
				bitmapData.draw(__clip, matrix);
				__bitmap.bitmapData = bitmapData;
			}
		}

		/**
		 * Deactivate the rendering of the MovieClip3D instance on every frame.
		 * 
		 * @see #activate()
		 */
		public function deactivate():void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		//----------------------------------------------------------------------------------------------------
		// Errors
		//----------------------------------------------------------------------------------------------------
		/**
		 * @private
		 */
		override public function get childrenSorted():Boolean {
			throw new Error("The MovieClip3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set childrenSorted(value:Boolean):void {
			throw new Error("The MovieClip3D class does not implement this property or method.");
		}
	}
}