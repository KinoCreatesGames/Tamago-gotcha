package en.collectibles;

class OinksterEgg extends Collectible {
  public function new(oinkEgg:Entity_Oinkster_Egg) {
    super(oinkEgg.cx, oinkEgg.cy);
  }

  override function setupGraphic() {
    super.setupGraphic();
  }
}