/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.display {
	import net.badimon.five3D.typography.Typography3D;

	import flash.geom.ColorTransform;	

	/**
	 * The DynamicText3D class is the equivalent in the FIVe3D package of the TextField class in the Flash package despite a different implementation.
	 */
	public class DynamicText3D extends Sprite3D {

		private var __text:String = "";
		private var __typography:Typography3D;
		private var __size:Number = 10;
		private var __color:uint = 0x000000;
		private var __letterSpacing:Number = 0;
		private var __textWidth:Number = 0;
		// Calculation
		private var __sizeMultiplicator:Number = __size / 100;

		/**
		 * Creates a new DynamicText3D instance.
		 * 
		 * @param typography	the Typography3D object that the DynamicText3D instance uses to display the text.
		 */
		public function DynamicText3D(typography:Typography3D) {
			__typography = typography;
		}

		//----------------------------------------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------------------------------------
		/**
		 * Indicates the current text of the DynamicText3D instance.
		 */
		public function get text():String {
			return __text;
		}

		public function set text(value:String):void {
			createGlyphs(value);
			__text = value;
			removeAdditionalGlyphs();
			placeGlyphs();
		}

		private function createGlyphs(text:String):void {
			var charOld:String, charNew:String, identical:Boolean = true;
			var len:int = text.length;
			for (var i:int = 0;i < len; i++) {
				charOld = __text.charAt(i);
				charNew = text.charAt(i);
				if ((charOld != charNew) || !identical) {
					createGlyph(i, charNew);
					identical = false;
				}
			}
		}

		private function createGlyph(index:Number, char:String):void {
			var shape:Shape3D = new Shape3D();
			shape.graphics3D.addMotif([['B', [__color, 1]]].concat(Graphics3D.clone(__typography.getMotif(char))).concat([['E']]));
			shape.scaleX = shape.scaleY = __sizeMultiplicator;
			addChildAt(shape, index);
		}

		private function removeAdditionalGlyphs():void {
			var num:int = numChildren;
			var len:int = __text.length;
			for (var i:int = num - 1;i >= len; i--) removeChildAt(i);
		}

		private function placeGlyphs():void {
			var offset:Number = 0;
			var num:int = numChildren;
			for (var i:int = 0;i < num; i++) {
				var shape:Shape3D = getChildAt(i) as Shape3D;
				if (shape.x != offset) shape.x = offset;
				if (i == num - 1) {
					__textWidth = offset + __typography.getWidth(__text.charAt(i)) * __sizeMultiplicator;
				} else {
					offset += (__typography.getWidth(__text.charAt(i)) + __letterSpacing) * __sizeMultiplicator;
				}
			}
		}

		/**
		 * Indicates the Typography3D object that the DynamicText3D instance uses to display the text.
		 */
		public function get typography():Typography3D {
			return __typography;
		}

		public function set typography(value:Typography3D):void {
			__typography = value;
			reinitText(__text);
		}

		private function reinitText(text:String):void {
			__text = "";
			this.text = text;
		}

		/**
		 * Indicates the text size (in pixels) of the DynamicText3D instance.
		 */
		public function get size():Number {
			return __size;
		}

		public function set size(value:Number):void {
			__size = value;
			__sizeMultiplicator = __size / 100;
			resizeGlyphs();
			placeGlyphs();
		}

		private function resizeGlyphs():void {
			var num:int = numChildren;
			for (var i:int = 0;i < num; i++) {
				var shape:Shape3D = getChildAt(i) as Shape3D;
				shape.scaleX = shape.scaleY = __sizeMultiplicator;
			}
		}

		/**
		 * Indicates the text color of the DynamicText3D instance.
		 */
		public function get color():uint {
			return __color;
		}

		public function set color(value:uint):void {
			__color = value;
			colorateGlyphs();
		}

		private function colorateGlyphs():void {
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = __color;
			var num:int = numChildren;
			for (var i:int = 0;i < num; i++) {
				var shape:Shape3D = getChildAt(i) as Shape3D;
				shape.transform.colorTransform = colorTransform;
			}
		}

		/**
		 * Indicates the amount of space between every character of the DynamicText3D instance.
		 */
		public function get letterSpacing():Number {
			return __letterSpacing;
		}

		public function set letterSpacing(value:Number):void {
			__letterSpacing = value;
			placeGlyphs();
		}

		/**
		 * Indicates the width of the text (in pixels) of the DynamicText3D instance.
		 */
		public function get textWidth():Number {
			return __textWidth;
		}

		//----------------------------------------------------------------------------------------------------
		// Errors
		//----------------------------------------------------------------------------------------------------
		/**
		 * @private
		 */
		override public function get graphics3D():Graphics3D {
			throw new Error("The DynamicText3D class does not implement this property or method.");
		}
	}
}