/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.utils {
	import net.badimon.five3D.display.Graphics3D;											

	/**
	 * The DrawingUtils class contains complex methods for drawing inside a Graphics3D instance.
	 */
	public class DrawingUtils {

		/**
		 * Draws a polygon into the Graphics3D object specified.
		 * 
		 * @param graphics		The Graphics3D to draw into.
		 * @param points		An array of points which form the polygon.
		 * @param color			The color of the fill.
		 * @param alpha			The alpha value of the fill (from 0.0 to 1.0).
		 */
		public static function polygon(graphics:Graphics3D, points:Array, color:uint, alpha:Number = 1.0):void {
			graphics.beginFill(color, alpha);
			tracePolygon(graphics, points);
			graphics.endFill();
		}

		private static function tracePolygon(graphics:Graphics3D, points:Array):void {
			var i:uint = points.length;
			graphics.moveTo(points[0].x, points[0].y);
			while (i--) graphics.lineTo(points[i].x, points[i].y);
		}

		/**
		 * Draws a star into the Graphics3D object specified.
		 * The center of the star is the registration point of the Graphics3D instance specified.
		 * 
		 * @param graphics		The Graphics3D to draw into.
		 * @param numTops		The number of tops which form the star. 
		 * @param radius1		The larger radius of the star (tops distance).
		 * @param radius2		The smaller radius of the star.
		 * @param angle			The rotation angle of the star on its center (in radians).
		 * @param color			The color of the fill.
		 * @param alpha			The alpha value of the fill (from 0.0 to 1.0).
		 * 
		 * @see #starPlace()
		 */
		public static function star(graphics:Graphics3D, numTops:uint, radius1:Number, radius2:Number, angle:Number, color:uint, alpha:Number = 1.0):void {
			graphics.beginFill(color, alpha);
			traceStar(graphics, 0, 0, numTops, radius1, radius2, angle);
			graphics.endFill();
		}

		/**
		 * Draws a star into the Graphics3D object specified.
		 * The center of the star is the point specified by the <code>x</code> and <code>y</code> parameters.
		 * 
		 * @param graphics		The Graphics3D to draw into.
		 * @param x				The x coordinate along the x-axis of the center of the star.
		 * @param y				The y coordinate along the y-axis of the center of the star.
		 * @param numTops		The number of tops which form the star.
		 * @param radius1		The larger radius of the star (tops distance).
		 * @param radius2		The smaller radius of the star.
		 * @param angle			The rotation angle of the star on its center (in radians).
		 * @param color			The color of the fill.
		 * @param alpha			The alpha value of the fill (from 0.0 to 1.0).
		 * 
		 * @see #star()
		 */
		public static function starPlace(graphics:Graphics3D, x:Number, y:Number, numTops:uint, radius1:Number, radius2:Number, angle:Number, color:uint, alpha:Number = 1.0):void {
			graphics.beginFill(color, alpha);
			traceStar(graphics, x, y, numTops, radius1, radius2, angle);
			graphics.endFill();
		}

		private static function traceStar(graphics:Graphics3D, x:Number, y:Number, numTops:uint, radius1:Number, radius2:Number, angle:Number):void {
			numTops *= 2;
			var angleStep:Number = Math.PI * 2 / numTops;
			graphics.moveTo(x + Math.cos(angle) * radius2, y + Math.sin(angle) * radius2);
			while (numTops--) {
				angle += angleStep;
				if (numTops % 2) graphics.lineTo(x + Math.cos(angle) * radius1, y + Math.sin(angle) * radius1);
				else graphics.lineTo(x + Math.cos(angle) * radius2, y + Math.sin(angle) * radius2);
			}
		}

		/**
		 * Draws a transparent gradient with a plain color.
		 * 
		 * @param graphics		The Graphics3D to draw into.
		 * @param width			The width of the gradient (in pixels).
		 * @param height		The height of the gradient (in pixels).
		 * @param color			The plain color of the transparent gradient.
		 * @param alpha1		The alpha value of the fill on the left side (from 0.0 to 1.0).
		 * @param alpha2		The alpha value of the fill on the right side (from 0.0 to 1.0).
		 * @param numSteps	The number of steps (sub rectangles) used to draw the gradient.
		 * 
		 * @see #gradientHorizontalPlainPlace()
		 */
		public static function gradientHorizontalPlain(graphics:Graphics3D, width:Number, height:Number, color:uint, alpha1:Number, alpha2:Number, numSteps:uint):void {
			var widthStep:Number = width / numSteps;
			var alphaStep:Number = (alpha2 - alpha1) / numSteps;
			for (var i:uint = 0;i < numSteps; i++) {
				graphics.beginFill(color, alpha1 + i * alphaStep);
				graphics.drawRect(i * widthStep, 0, widthStep, height);
				graphics.endFill();
			}
		}

		/**
		 * Draws a transparent gradient with a plain color.
		 * The top left corner of the gradient is the point specified by the <code>x</code> and <code>y</code> parameters.
		 * 
		 * @param graphics		The Graphics3D to draw into.
		 * @param x				The x coordinate along the x-axis of the top left corner of the gradient.
		 * @param y				The y coordinate along the y-axis of the top left corner of the gradient.
		 * @param width			The width of the gradient (in pixels).
		 * @param height		The height of the gradient (in pixels).
		 * @param color			The plain color of the transparent gradient.
		 * @param alpha1		The alpha value of the fill on the left side (from 0.0 to 1.0).
		 * @param alpha2		The alpha value of the fill on the right side (from 0.0 to 1.0).
		 * @param numSteps	The number of steps (sub rectangles) used to draw the gradient.
		 * 
		 * @see #gradientHorizontalPlain()
		 */
		public static function gradientHorizontalPlainPlace(graphics:Graphics3D, x:Number, y:Number, width:Number, height:Number, color:uint, alpha1:Number, alpha2:Number, numSteps:uint):void {
			var widthStep:Number = width / numSteps;
			var alphaStep:Number = (alpha2 - alpha1) / numSteps;
			for (var i:uint = 0;i < numSteps; i++) {
				graphics.beginFill(color, alpha1 + i * alphaStep);
				graphics.drawRect(x + i * widthStep, y, widthStep, height);
				graphics.endFill();
			}
		}
	}
}