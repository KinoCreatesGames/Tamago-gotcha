package en.collectibles;

class BlueEgg extends BaseEgg {
  public function new(b_Egg:Entity_BlueEgg) {
    super(b_Egg.cx, b_Egg.cy);
  }

  override function setupGraphic() {
    var g = this.spr.createGraphics();
    var size = Const.GRID;
    var tile = Assets.gameTiles.getTile(Assets.gameTilesDict.BlueEgg);
    g.beginTileFill(tile);
    g.drawRect(0, 0, size, size);
    g.endFill();
    g.y -= 32;
    g.x -= 16;
    g.blendMode = Alpha;
    // g.filter
    g.addShader(visibleShader);
  }
}