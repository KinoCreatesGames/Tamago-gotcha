package shaders;

import h3d.shader.ScreenShader;
import hxsl.Types.Sampler2D;

class VisibilityFilter extends h2d.filter.Shader<InternalShader> {
  public function new() {
    super(new InternalShader(0, hxd.Res.textures.VisibleTexture.toTexture()));
  }

  public function setVisiblePerc(val:Float) {
    this.shader.visiblePerc = val;
  }
}

/**
 * Works by adjusting the visible alpha levels
 * of the sprite using the distance from the current position
 * to the  element.
 */
private class InternalShader extends ScreenShader {
  static var SRC = {
    // @:import h3d.shader.Base2d; // Necessary for 2D Shaders

    /**
     * The visibility percentage for the 
     * sprite within the game.
     */
    @param var visiblePerc:Float;

    /**
     * The texture used to sample from. 
     * It determines how the alpha will be calculated.
     */
    @param var texture:Sampler2D;

    function fragment() {
      var texColor = texture.get(input.uv);
      //   if (texColor.b > visiblePerc) {
      // pixelColor.a = 0;
      //   } else {
      //   var cl = input.uv.y;
      // pixelColor.rgb = vec3(texColor.r);
      pixelColor = pixelColor;
      //   }
    }
  }

  public function new(visiblePerc:Float = 0, texture:h3d.mat.Texture) {
    super();
    this.texture = texture;
    this.visiblePerc = visiblePerc;
  }
}