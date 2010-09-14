/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FIVe3D
Flash Interactive Vector-based 3D
Mathieu Badimon  |  five3d@mathieu-badimon.com

http://five3D.mathieu-badimon.com  |  http://five3d.mathieu-badimon.com/archives/  |  http://code.google.com/p/five3d/

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

package net.badimon.five3D.display {
	import net.badimon.five3D.geom.Matrix3D;
	import net.badimon.five3D.geom.Point3D;
	
	import flash.display.Graphics;	

	/**
	 * The Graphics3D class is the equivalent in the FIVe3D package of the Graphics class in the Flash package.
	 * 
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/Graphics.html
	 */
	public final class Graphics3D {

		private var __motif:Array;
		private var __render:Boolean = false;

		/**
		 * @private
		 */
		public function Graphics3D() {
			__motif = [];
		}

		/**
		 * Specifies a simple one-color fill that subsequent calls to drawing methods use when drawing.
		 * 
		 * <p>This property has the same behavior than the normal Graphics <code>beginFill</code> method.</p>
		 * 
		 * @param color		The color of the fill.
		 * @param alpha		The alpha value of the fill (from 0.0 to 1.0).
		 */
		public function beginFill(color:uint, alpha:Number = 1.0):void {
			__motif.push(['B', [color, alpha]]);
			askRendering();
		}

		/**
		 * Clears the graphics that were drawn to this Graphics3D instance, and resets fill and line style settings.
		 * 
		 * <p>This property has the same behavior than the normal Graphics <code>clear</code> method.</p>
		 */
		public function clear():void {
			__motif = [];
			askRendering();
		}

		/**
		 * Draws a curve from the current drawing position to (anchorX, anchorY) and using the control point that (controlX, controlY) specifies.
		 * 
		 * <p>This property has the same behavior than the normal Graphics <code>curveTo</code> method.</p>
		 * 
		 * @param controlX	The x coordinate of the control point along the x-axis relative to the registration point of the 3D parent container.
		 * @param controlY	The y coordinate of the control point along the y-axis relative to the registration point of the 3D parent container.
		 * @param anchorX	The x coordinate of the next anchor point along the x-axis relative to the registration point of the 3D parent container.
		 * @param anchorY	The y coordinate of the next anchor point along the y-axis relative to the registration point of the 3D parent container.
		 * 
		 * @see #curveToSpace()
		 */
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void {
			__motif.push(['C', [controlX, controlY, anchorX, anchorY]]);
			askRendering();
		}

		/**
		 * Draws a curve in space from the current drawing position to (anchorX, anchorY, anchorZ) and using the control point that (controlX, controlY, controlZ) specifies.
		 * 
		 * @param controlX	The x coordinate of the control point along the x-axis relative to the registration point of the 3D parent container.
		 * @param controlY	The y coordinate of the control point along the y-axis relative to the registration point of the 3D parent container.
		 * @param controlZ	The z coordinate of the control point along the z-axis relative to the registration point of the 3D parent container.
		 * @param anchorX	The x coordinate of the next anchor point along the x-axis relative to the registration point of the 3D parent container.
		 * @param anchorY	The y coordinate of the next anchor point along the y-axis relative to the registration point of the 3D parent container.
		 * @param anchorZ	The z coordinate of the next anchor point along the z-axis relative to the registration point of the 3D parent container.
		 * 
		 * @see #curveTo()
		 */
		public function curveToSpace(controlX:Number, controlY:Number, controlZ:Number, anchorX:Number, anchorY:Number, anchorZ:Number):void {
			__motif.push(['C', [controlX, controlY, controlZ, anchorX, anchorY, anchorZ]]);
			askRendering();
		}

		/**
		 * Draws a circle with the fill and line style settings previously defined.
		 * 
		 * <p>This property has the same behavior than the normal Graphics <code>drawCircle</code> method.</p>
		 * 
		 * @param x			The x coordinate of the center of the circle relative to the registration point of the 3D parent container. 
		 * @param y			The y coordinate of the center of the circle relative to the registration point of the 3D parent container.
		 * @param radius	The radius of the circle.
		 */
		public function drawCircle(x:Number, y:Number, radius:Number):void {
			var A:Number = radius * (Math.SQRT2 - 1);
			var B:Number = radius / Math.SQRT2;
			__motif.push(['M', [x, y - radius]], ['C', [x + A, y - radius, x + B, y - B]], ['C', [x + radius, y - A, x + radius, y]], ['C', [x + radius, y + A, x + B, y + B]], ['C', [x + A, y + radius, x, y + radius]], ['C', [x - A, y + radius, x - B, y + B]], ['C', [x - radius, y + A, x - radius, y]], ['C', [x - radius, y - A, x - B, y - B]], ['C', [x - A, y - radius, x, y - radius]]);
			askRendering();
		}

		/**
		 * Draws an ellipse with the fill and line style settings previously defined.
		 * 
		 * <p>This property has the same behavior than the normal Graphics <code>drawEllipse</code> method.</p>
		 * 
		 * @param x			The x coordinate of the top left corner of the bounding box of the ellipse relative to the registration point of the 3D parent container.
		 * @param y			The y coordinate of the top left corner of the bounding box of the ellipse relative to the registration point of the 3D parent container.
		 * @param width		The width of the ellipse.
		 * @param height	The height of the ellipse.
		 */
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void {
			var x2:Number = x + width / 2;
			var y2:Number = y + height / 2;
			var radiusWidth:Number = width / 2;
			var radiusHeight:Number = height / 2;
			var AW:Number = radiusWidth * (Math.SQRT2 - 1);
			var BW:Number = radiusWidth / Math.SQRT2;
			var AH:Number = radiusHeight * (Math.SQRT2 - 1);
			var BH:Number = radiusHeight / Math.SQRT2;
			__motif.push(['M', [x2, y2 - radiusHeight]], ['C', [x2 + AW, y2 - radiusHeight, x2 + BW, y2 - BH]], ['C', [x2 + radiusWidth, y2 - AH, x2 + radiusWidth, y2]], ['C', [x2 + radiusWidth, y2 + AH, x2 + BW, y2 + BH]], ['C', [x2 + AW, y2 + radiusHeight, x2, y2 + radiusHeight]], ['C', [x2 - AW, y2 + radiusHeight, x2 - BW, y2 + BH]], ['C', [x2 - radiusWidth, y2 + AH, x2 - radiusWidth, y2]], ['C', [x2 - radiusWidth, y2 - AH, x2 - BW, y2 - BH]], ['C', [x2 - AW, y2 - radiusHeight, x2, y2 - radiusHeight]]);
			askRendering();
		}

		/**
		 * Draws a rectangle with the fill and line style settings previously defined.
		 * 
		 * <p>This property has the same behavior than the normal Graphics <code>drawRect</code> method.</p>
		 * 
		 * @param x			The x coordinate of the top left corner of the rectangle relative to the registration point of the 3D parent container.
		 * @param y			The y coordinate of the top left corner of the rectangle relative to the registration point of the 3D parent container.
		 * @param width		The width of the rectangle.
		 * @param height	The height of the rectangle.
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void {
			__motif.push(['M', [x, y]], ['L', [x + width, y]], ['L', [x + width, y + height]], ['L', [x, y + height]], ['L', [x, y]]);
			askRendering();
		}

		/**
		 * Draws a rounded rectangle with the fill and line style settings previously defined.
		 * 
		 * <p>This property has the same behavior than the normal Graphics <code>drawRoundRect</code> method.</p>
		 * 
		 * @param x				The x coordinate of the top left corner of the rounded rectangle relative to the registration point of the 3D parent container.
		 * @param y				The x coordinate of the top left corner of the rounded rectangle relative to the registration point of the 3D parent container.
		 * @param width			The width of the rounded rectangle.
		 * @param height		The height of the rounded rectangle.
		 * @param ellipseWidth	The width of the ellipse used to draw the rounded corners.
		 * @param ellipseHeight	The height of the ellipse used to draw the rounded corners. Optional; if no value is specified, the default value matches the <code>ellipseWidth</code> parameter provided.
		 */
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = NaN):void {
			var x2:Number = x + width;
			var y2:Number = y + height;
			var radiusWidth:Number = Math.min(ellipseWidth / 2, width / 2);
			var radiusHeight:Number = (isNaN(ellipseHeight)) ? radiusWidth : Math.min(ellipseHeight / 2, height / 2);
			var AW:Number = radiusWidth * (Math.SQRT2 - 1);
			var BW:Number = radiusWidth / Math.SQRT2;
			var AH:Number = radiusHeight * (Math.SQRT2 - 1);
			var BH:Number = radiusHeight / Math.SQRT2;
			__motif.push(['M', [x + radiusWidth, y]], ['L', [x2 - radiusWidth, y]], ['C', [x2 - radiusWidth + AW, y, x2 - radiusWidth + BW, y + radiusHeight - BH]], ['C', [x2, y + radiusHeight - AH, x2, y + radiusHeight]], ['L', [x2, y2 - radiusHeight]], ['C', [x2, y2 - radiusHeight + AH, x2 - radiusWidth + BW, y2 - radiusHeight + BH]], ['C', [x2 - radiusWidth + AW, y2, x2 - radiusWidth, y2]], ['L', [x + radiusWidth, y2]], ['C', [x + radiusWidth - AW, y2, x + radiusWidth - BW, y2 - radiusHeight + BH]], ['C', [x, y2 - radiusHeight + AH, x, y2 - radiusHeight]], ['L', [x, y + radiusHeight]], ['C', [x, y + radiusHeight - AH, x + radiusWidth - BW, y + radiusHeight - BH]], ['C', [x + radiusWidth - AW, y, x + radiusWidth, y]]);
			askRendering();
		}

		/**
		 * Applies a fill to the lines and curves that were added since the last call to the <code>beginFill</code> method.
		 * 
		 * <p>This property has the same behavior than the normal Graphics <code>endFill</code> method.</p>
		 */
		public function endFill():void {
			__motif.push(['E']);
			askRendering();
		}

		/**
		 * Specifies a line style that subsequent calls to drawing methods use when drawing.
		 * 
		 * <p>This property has the same behavior than the normal Graphics <code>lineStyle</code> method.</p>
		 * 
		 * @param thickness		The thickness of the line (in points from 0 to 255).
		 * @param color			The color of the line.
		 * @param alpha			The alpha value of the line (from 0.0 to 1.0).
		 * @param pixelHinting	Whether to hint strokes to full pixels.
		 * @param scaleMode	The line scale mode to use.
		 * @param caps			The type of caps at the end of lines.
		 * @param joints			The type of joint appearance used at angles.
		 * @param miterLimit		The limit at which a miter is cut off.
		 */
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void {
			__motif.push(['S', [thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit]]);
			askRendering();
		}

		/**
		 * Draws a line from the current drawing position to (x, y). The current drawing position is then set to (x, y).
		 * 
		 * <p>This property has the same behavior than the normal Graphics <code>lineTo</code> method.</p>
		 * 
		 * @param x			The x coordinate along the x-axis relative to the registration point of the 3D parent container.
		 * @param y			The y coordinate along the y-axis relative to the registration point of the 3D parent container.
		 * 
		 * @see #lineToSpace()
		 */
		public function lineTo(x:Number, y:Number):void {
			__motif.push(['L', [x, y]]);
			askRendering();
		}

		/**
		 * Draws a line in space from the current drawing position to (x, y, z). The current drawing position is then set to (x, y, z).
		 * 
		 * @param x			The x coordinate along the x-axis relative to the registration point of the 3D parent container.
		 * @param y			The y coordinate along the y-axis relative to the registration point of the 3D parent container.
		 * @param z			The z coordinate along the z-axis relative to the registration point of the 3D parent container.
		 * 
		 * @see #lineTo()
		 */
		public function lineToSpace(x:Number, y:Number, z:Number):void {
			__motif.push(['L', [x, y, z]]);
			askRendering();
		}

		/**
		 * Moves the current drawing position to (x, y).
		 * 
		 * <p>This property has the same behavior than the normal Graphics <code>moveTo</code> method.</p>
		 * 
		 * @param x			The x coordinate along the x-axis relative to the registration point of the 3D parent container.
		 * @param y			The y coordinate along the y-axis relative to the registration point of the 3D parent container.
		 * 
		 * @see #moveToSpace()
		 */
		public function moveTo(x:Number, y:Number):void {
			__motif.push(['M', [x, y]]);
			askRendering();
		}

		/**
		 * Moves the current drawing position in space to (x, y, z).
		 * 
		 * @param x			The x coordinate along the x-axis relative to the registration point of the 3D parent container.
		 * @param y			The y coordinate along the y-axis relative to the registration point of the 3D parent container.
		 * @param z			The y coordinate along the z-axis relative to the registration point of the 3D parent container.
		 * 
		 * @see #moveTo()
		 */
		public function moveToSpace(x:Number, y:Number, z:Number):void {
			__motif.push(['M', [x, y, z]]);
			askRendering();
		}

		/**
		 * Adds drawing instructions (motif) to the existing drawing intructions stored in the Graphics3D instance.
		 * 
		 * @param motif		The drawing instructions (motif) to be added.
		 * 
		 */
		public function addMotif(motif:Array):void {
			__motif = __motif.concat(motif);
			askRendering();
		}

		/**
		 * @private
		 */
		internal function askRendering():void {
			__render = true;
		}

		/**
		 * @private
		 */
		internal function render(graphics:Graphics, matrix:Matrix3D, viewDistance:Number):void {
			if (__render) {
				draw(graphics, matrix, viewDistance);
				__render = false;
			}
		}

		private function draw(graphics:Graphics, matrix:Matrix3D, viewDistance:Number):void {
			var point1:Point3D, point2:Point3D;
			graphics.clear();
			var len:int = __motif.length;
			for (var i:int = 0;i < len; i++) {
				switch (__motif[i][0]) {
					case "B":
						graphics.beginFill(__motif[i][1][0], __motif[i][1][1]);
						break;
					case "S":
						graphics.lineStyle(__motif[i][1][0], __motif[i][1][1], __motif[i][1][2], __motif[i][1][3], __motif[i][1][4], __motif[i][1][5], __motif[i][1][6], __motif[i][1][7]);
						break;
					case "M":
						point1 = (__motif[i][1].length == 2) ? new Point3D(__motif[i][1][0], __motif[i][1][1]) : new Point3D(__motif[i][1][0], __motif[i][1][1], __motif[i][1][2]);
						point1 = matrix.transformPoint(point1);
						point1.project(point1.getPerspective(viewDistance));
						graphics.moveTo(point1.x, point1.y);
						break;
					case "L":
						point1 = (__motif[i][1].length == 2) ? new Point3D(__motif[i][1][0], __motif[i][1][1]) : new Point3D(__motif[i][1][0], __motif[i][1][1], __motif[i][1][2]);
						point1 = matrix.transformPoint(point1);
						point1.project(point1.getPerspective(viewDistance));
						graphics.lineTo(point1.x, point1.y);
						break;
					case "C":
						if (__motif[i][1].length == 4) {
							point1 = new Point3D(__motif[i][1][0], __motif[i][1][1]);
							point2 = new Point3D(__motif[i][1][2], __motif[i][1][3]);
						} else {
							point1 = new Point3D(__motif[i][1][0], __motif[i][1][1], __motif[i][1][2]);
							point2 = new Point3D(__motif[i][1][3], __motif[i][1][4], __motif[i][1][5]);
						}
						point1 = matrix.transformPoint(point1);
						point2 = matrix.transformPoint(point2);
						point1.project(point1.getPerspective(viewDistance));
						point2.project(point2.getPerspective(viewDistance));
						graphics.curveTo(point1.x, point1.y, point2.x, point2.y);
						break;
					case "E":
						graphics.endFill();
						break;
				}
			}
		}

		/**
		 * Clones the drawing instructions (motif) passed as parameter.
		 * 
		 * @param motif		The drawing instructions (motif) to be cloned.
		 */
		public static function clone(motif:Array):Array {
			var motif2:Array = [];
			var len:int = motif.length;
			for (var i:int = 0;i < len; i++) {
				switch (motif[i][0]) {
					case "B":
						motif2.push(['B', [motif[i][1][0], motif[i][1][1]]]);
						break;
					case "S":
						motif2.push(['S', [motif[i][1][0], motif[i][1][1], motif[i][1][2], motif[i][1][3], motif[i][1][4], motif[i][1][5], motif[i][1][6], motif[i][1][7]]]);
						break;
					case "M":
						motif2.push(['M', (motif[i][1].length == 2) ? [motif[i][1][0], motif[i][1][1]] : [motif[i][1][0], motif[i][1][1], motif[i][1][2]]]);
						break;
					case "L":
						motif2.push(['L', (motif[i][1].length == 2) ? [motif[i][1][0], motif[i][1][1]] : [motif[i][1][0], motif[i][1][1], motif[i][1][2]]]);
						break;
					case "C":
						motif2.push(['C', (motif[i][1].length == 4) ? [motif[i][1][0], motif[i][1][1], motif[i][1][2], motif[i][1][3]] : [motif[i][1][0], motif[i][1][1], motif[i][1][2], motif[i][1][3], motif[i][1][4], motif[i][1][5]]]);
						break;
					case "E":
						motif2.push(['E']);
						break;
				}
			}
			return motif2;
		}
	}
}