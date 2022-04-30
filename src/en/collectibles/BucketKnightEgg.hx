package en.collectibles;

class BucketKnightEgg extends BaseEgg {
  public function new(bkEgg:Entity_BucketKnight_Egg) {
    super(bkEgg.cx, bkEgg.cy);
  }

  override function setupGraphic() {
    var g = this.spr.createGraphics();
    var size = Const.GRID;
    var tile = Assets.eggTiles.getTile(Assets.eggTilesDict.BucketKnight);
    g.beginTileFill(tile);
    g.drawRect(0, 0, size, size);
    g.endFill();
    g.y -= 32;
    g.x -= 16;

    g.addShader(visibleShader);
  }
}