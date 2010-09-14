/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.utils {
	import net.badimon.five3D.display.IObject3D;
	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.geom.Matrix3D;
	import net.badimon.five3D.geom.Point3D;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.ColorTransform;	

	/**
	 * @private
	 */
	public class InternalUtils {

		public static const DEG_TO_RAD:Number = Math.PI / 180;

		public static function formatRotation(angle:Number):Number {
			if (angle >= -180 && angle <= 180) return angle;
			var angle2:Number = angle % 360;
			if (angle2 < -180) return angle2 + 360;
			if (angle2 > 180) return angle2 - 360;
			return angle2;
		}

		public static function setMatrix(matrix:Matrix3D, x:Number, y:Number, z:Number, rotationX:Number, rotationY:Number, rotationZ:Number, scaleX:Number, scaleY:Number, scaleZ:Number):void {
			matrix.createBox(scaleX, scaleY, scaleZ, rotationX * DEG_TO_RAD, rotationY * DEG_TO_RAD, rotationZ * DEG_TO_RAD, x, y, z);
		}

		public static function setMatrixPosition(matrix:Matrix3D, x:Number, y:Number, z:Number):void {
			matrix.identity();
			if (x != 0 || y != 0 || z != 0) matrix.translate(x, y, z);
		}

		public static function setConcatenatedMatrix(parent:DisplayObjectContainer, matrix:Matrix3D):Matrix3D {
			if (parent is Scene3D) {
				return matrix.clone();
			} else {
				var concatenatedMatrix:Matrix3D = IObject3D(parent).concatenatedMatrix.clone();
				concatenatedMatrix.concat(matrix);
				return concatenatedMatrix;
			}
		}

		public static function setFlatShading(object:DisplayObject, normalVectorNormalized:Point3D, ambientLightVectorNormalized:Point3D, ambientLightIntensity:Number, alpha:Number):void {
			var dot:Number = normalVectorNormalized.dot(ambientLightVectorNormalized);
			var brightness:Number = dot * ambientLightIntensity;
			var colorTransform:ColorTransform = new ColorTransform();
			setColorTransformBrightness(colorTransform, brightness);
			colorTransform.alphaMultiplier = alpha;
			object.transform.colorTransform = colorTransform;
		}

		private static function setColorTransformBrightness(colorTransform:ColorTransform, value:Number):void {
			if (value > 1) value = 1;
			else if (value < -1) value = -1;
			var percent:Number = 1 - Math.abs(value);
			var offset:Number = 0;
			if (value > 0) offset = value * 255;
			colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = percent;
			colorTransform.redOffset = colorTransform.greenOffset = colorTransform.blueOffset = offset;
		}

		public static function getScene(object:DisplayObject):Scene3D {
			while (object = object.parent) {
				if (object is Scene3D) return object as Scene3D;
			}
			return null;
		}
	}
}