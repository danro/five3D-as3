/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.display {
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetStream;	

	/**
	 * The Video3D class is the equivalent in the FIVe3D package of the Bitmap class in the Flash package.
	 * 
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Video.html
	 */
	public class Video3D extends Bitmap3D {

		private var __video:Video;

		/**
		 * Creates a new Video3D instance.
		 */
		public function Video3D(width:int = 320, height:int = 240) {
			__video = new Video(width, height);
		}

		//----------------------------------------------------------------------------------------------------
		// Properties (from normal "Video" class)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Indicates the type of filter applied to decode video as part of post-processing.
		 * 
		 * <p>This property has the same behavior than the normal Video <code>deblocking</code> property.</p>
		 */
		public function get deblocking():int {
			return __video.deblocking;
		}

		public function set deblocking(value:int):void {
			__video.deblocking = value;
		}

		/**
		 * Indicates the width (in pixels) of the video stream.
		 * 
		 * <p>This property has the same behavior than the normal Video <code>videoWidth</code> property.</p>
		 */
		public function get videoWidth():int {
			return __video.videoWidth;
		}

		/**
		 * Indicates the height (in pixels) of the video stream.
		 * 
		 * <p>This property has the same behavior than the normal Video <code>videoHeight</code> property.</p>
		 */
		public function get videoHeight():int {
			return __video.videoHeight;
		}

		//----------------------------------------------------------------------------------------------------
		// Methods (from normal "Video" class)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Specifies a video stream from a camera to be displayed within the boundaries of the Video3D instance.
		 * 
		 * <p>This property has the same behavior than the normal Video <code>attachCamera</code> property.</p>
		 * 
		 * @param camera		A Camera object that is capturing video data. To drop the connection to the Video object, pass null.
		 * 
		 * @see #activate()
		 * @see #deactivate()
		 */
		public function attachCamera(camera:Camera):void {
			__video.attachCamera(camera);
		}

		/**
		 * Specifies a video stream to be displayed within the boundaries of the Video3D instance.
		 * 
		 * <p>This property has the same behavior than the normal Video <code>attachNetStream</code> property.</p>
		 * 
		 * @param netstream		A NetStream object. To drop the connection to the Video object, pass null.
		 * 
		 * @see #activate()
		 * @see #deactivate()
		 */
		public function attachNetStream(netstream:NetStream):void {
			__video.attachNetStream(netstream);
		}

		/**
		 * Clears the image currently displayed in the Video3D instance (not the video stream).
		 * 
		 * <p>This property has the same behavior than the normal Video <code>clear</code> property.</p>
		 */
		public function clear():void {
			super.bitmapData = null;
		}

		//----------------------------------------------------------------------------------------------------
		// Methods (new)
		//----------------------------------------------------------------------------------------------------
		/**
		 * Activate the rendering of the video. The video stream input is drawn into the Video3D instance on every frame.
		 * A call to this method is necessary in order to display the video stream previously specified.
		 * 
		 * @see #deactivate()
		 */
		public function activate():void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void {
			var bitmapData:BitmapData = new BitmapData(__video.width, __video.height, false);
			bitmapData.draw(__video);
			super.bitmapData = bitmapData;
		}

		/**
		 * Deactivate the rendering of the video. The video stream input is not drawn into the Video3D instance on every frame.
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
		override public function get bitmapData():BitmapData {
			throw new Error("The Video3D class does not implement this property or method.");
		}

		/**
		 * @private
		 */
		override public function set bitmapData(value:BitmapData):void {
			throw new Error("The Video3D class does not implement this property or method.");
		}
	}
}