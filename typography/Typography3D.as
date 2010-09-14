/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.typography {

	/**
	 * The Typography3D class is the base class for all typography 3D objects that can be used to display text.
	 */
	public class Typography3D {

		protected var motifs:Object = {};
		protected var widths:Object = {};
		protected var height:Number;

		/**
		 * Returns the motif (drawing instructions) of a character.
		 * 
		 * @param char	The character of which the motif will be returned.
		 */
		public function getMotif(char:String):Array {
			return motifs[char];
		}

		/**
		 * Returns the width of a character.
		 * 
		 * @param char	The character of which the width will be returned.
		 */
		public function getWidth(char:String):Number {
			return widths[char];
		}

		/**
		 * Returns the Typography3D instance line height.
		 */
		public function getHeight():Number {
			return height;
		}
	}
}