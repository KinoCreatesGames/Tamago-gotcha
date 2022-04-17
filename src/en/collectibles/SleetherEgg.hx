package en.collectibles;

class SleetherEgg extends Collectible {
  public function new(sleetherEgg:Entity_Sleether_Egg) {
    super(sleetherEgg.cx, sleetherEgg.cy);
  }

  override function setupGraphic() {
    super.setupGraphic();
  }
}