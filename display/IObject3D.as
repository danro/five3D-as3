/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.display {
	import net.badimon.five3D.geom.Matrix3D;							

	/**
	 * The IObject3D interface is the base interface for all 3D objects that can be placed in a FIVe3D Scene3D object display list.
	 */
	public interface IObject3D {

		/**
		 * Indicates a Matrix3D object representing the combined transformation matrixes of the IObject3D instance and all of its parent 3D objects, back to the scene level.
		 */
		function get concatenatedMatrix():Matrix3D;

		/**
		 * @private
		 */
		function askRendering():void;

		/**
		 * @private
		 */
		function askRenderingShading():void;

		/**
		 * @private
		 */
		function render(scene:Scene3D):void;
	}
}