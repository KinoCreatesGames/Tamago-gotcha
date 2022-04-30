package shaders;

import hxsl.Types.Sampler2D;

/**
 * Works by adjusting the visible alpha levels
 * of the sprite using the distance from the current position
 * to the  element.
 */
class DistanceToColor2D extends hxsl.Shader {
  static var SRC = {
    @:import h3d.shader.Base2d; // Necessary for 2D Shaders

    /**
     * The distance percentage for the 
     * sprite within the game from target..
     */
    @param var distancePerc:Float;

    /**
     * The texture used to sample from. 
     * It determines how the alpha will be calculated.
     */
    function fragment() {
      // if (texColor.b > visiblePerc) {
      if (pixelColor.a > 0) {
        pixelColor.b = 1 - distancePerc;
        // pixelColor.r = distancePerc;
        pixelColor.g = 1 - distancePerc;
      }
      // } else {
      // var cl = input.uv.x;
      // pixelColor.rgb = vec3(cl);
      // pixelColor = pixelColor;
      // }
    }
  }

  public function new(distancePerc:Float = 0) {
    super();
    this.distancePerc = distancePerc;
  }
}