package en.collectibles;

class OinksterEgg extends BaseEgg {
  public function new(oinkEgg:Entity_Oinkster_Egg) {
    super(oinkEgg.cx, oinkEgg.cy);
  }

  override function setupGraphic() {
    var g = this.spr.createGraphics();
    var size = Const.GRID;
    var tile = Assets.eggTiles.getTile(Assets.eggTilesDict.Oinkster);
    g.beginTileFill(tile);
    g.drawRect(0, 0, size, size);
    g.endFill();
    g.y -= 32;
    g.x -= 16;

    g.addShader(visibleShader);
  }
}