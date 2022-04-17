package en.collectibles;

class BucketKnightEgg extends Collectible {
  public function new(bkEgg:Entity_BucketKnight_Egg) {
    super(bkEgg.cx, bkEgg.cy);
  }
}