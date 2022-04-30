package en.collectibles;

class Ropelli802Egg extends BaseEgg {
  public function new(rpEgg:Entity_Ropelli802_Egg) {
    super(rpEgg.cx, rpEgg.cy);
  }

  override function setupGraphic() {
    var g = this.spr.createGraphics();
    var size = Const.GRID;
    var tile = Assets.eggTiles.getTile(Assets.eggTilesDict.Ropelli);
    g.beginTileFill(tile);
    g.drawRect(0, 0, size, size);
    g.endFill();
    g.y -= 32;
    g.x -= 16;

    g.addShader(visibleShader);
  }
}