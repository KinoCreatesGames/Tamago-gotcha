package en.collectibles;

class SleetherEgg extends BaseEgg {
  public function new(sleetherEgg:Entity_Sleether_Egg) {
    super(sleetherEgg.cx, sleetherEgg.cy);
  }

  override function setupGraphic() {
    var g = this.spr.createGraphics();
    var size = Const.GRID;
    var tile = Assets.eggTiles.getTile(Assets.eggTilesDict.Sleether);
    g.beginTileFill(tile);
    g.drawRect(0, 0, size, size);
    g.endFill();
    g.y -= 32;
    g.x -= 16;

    g.addShader(visibleShader);
  }
}