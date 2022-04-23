package en.collectibles;

/**
 * Base Entity of all eggs within the game.
 */
class Egg extends BaseEgg {
  public function new(e_Egg:Entity_Egg) {
    super(e_Egg.cx, e_Egg.cy);
  }

  override function setupGraphic() {
    var g = this.spr.createGraphics();
    var size = Const.GRID;
    var tile = Assets.gameTiles.getTile(Assets.gameTilesDict.Egg);
    g.beginTileFill(tile);
    g.drawRect(0, 0, size, size);
    g.endFill();
    g.y -= 32;
    g.x -= 16;
  }
}