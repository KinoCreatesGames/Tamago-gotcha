package en.collectibles;

import shaders.VisibilityFilter;
import shaders.VisibilityShader2D;

class BaseEgg extends Collectible {
  public var visibleShader:VisibilityShader2D;

  public function new(x:Int, y:Int) {
    setupShader();
    super(x, y);
  }

  public function setupShader() {
    visibleShader = new VisibilityShader2D(0);
    visibleShader.tex = hxd.Res.textures.VisibleTexture.toTexture();
    // this.spr.filter = new VisibilityFilter();
    // this.spr.addShader(visibleShader);
  }
}