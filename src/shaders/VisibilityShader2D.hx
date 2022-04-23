package shaders;

import hxsl.Types.Sampler2D;

/**
 * Works by adjusting the visible alpha levels
 * of the sprite using the distance from the current position
 * to the  element.
 */
class VisibilityShader2D extends hxsl.Shader {
  static var SRC = {
    @:import h3d.shader.Base2d; // Necessary for 2D Shaders

    /**
     * The visibility percentage for the 
     * sprite within the game.
     */
    @param var visiblePerc:Float;

    /**
     * The texture used to sample from. 
     * It determines how the alpha will be calculated.
     */
    @param var tex:Sampler2D;

    function fragment() {
      var texColor = tex.get(input.uv);
      if (texColor.r < visiblePerc) {
        pixelColor.a = 0;
      } else {
        pixelColor = pixelColor;
      }
    }
  }

  public function new(visiblePerc:Float = 0) {
    super();
    this.visiblePerc = visiblePerc;
  }
}