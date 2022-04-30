import shaders.VisibilityFilter;
import h2d.col.Point;
import en.collectibles.BaseEgg;
import en.collectibles.BlueEgg;
import scn.GameOver;
import scn.Pause;
import en.Enemy;
import h3d.Vector;
import GameTypes.DetectionLevel;
import en.collectibles.Egg;
import en.collectibles.OinksterEgg;
import en.collectibles.Ropelli802Egg;
import en.collectibles.SleetherEgg;
import en.collectibles.BucketKnightEgg;
import en.Player;
import en.Collectible;

class Level extends dn.Process {
  var game(get, never):Game;

  inline function get_game()
    return Game.ME;

  var fx(get, never):Fx;

  inline function get_fx()
    return Game.ME.fx;

  /** Level grid-based width**/
  public var cWid(get, never):Int;

  inline function get_cWid()
    return 16;

  /** Level grid-based height **/
  public var cHei(get, never):Int;

  inline function get_cHei()
    return 16;

  /** Level pixel width**/
  public var pxWid(get, never):Int;

  inline function get_pxWid()
    return cWid * Const.GRID;

  /** Level pixel height**/
  public var pxHei(get, never):Int;

  inline function get_pxHei()
    return cHei * Const.GRID;

  var invalidated = true;

  public var scnPause:Pause;
  public var scnGameOver:GameOver;

  public var data:LDTkProj_Level;

  // Groups & Player
  public var player:Player;
  public var collectibles:Group<Collectible>;
  public var enemies:Group<Enemy>;
  public var eggs:Group<BaseEgg>;

  /**
   * The Score on the level for collecting 
   * eggs.
   */
  public var score:Int;

  public function new(level:LDTkProj_Level) {
    super(Game.ME);
    this.data = level;
    createRootInLayers(Game.ME.scroller, Const.DP_BG);
    setup();
  }

  /** TRUE if given coords are in level bounds **/
  public inline function isValid(cx, cy)
    return cx >= 0 && cx < cWid && cy >= 0 && cy < cHei;

  /** Gets the integer ID of a given level grid coord **/
  public inline function coordId(cx, cy)
    return cx + cy * cWid;

  /** Ask for a level render that will only happen at the end of the current frame. **/
  public inline function invalidate() {
    invalidated = true;
  }

  public function setup() {
    createGroups();
    createEntities();
  }

  public function createGroups() {
    collectibles = new Group<Collectible>();
    enemies = new Group<Enemy>();
    eggs = new Group<BaseEgg>();
  }

  public function createEntities() {
    for (pl in data.l_Entities.all_Player) {
      player = new Player(pl.cx, pl.cy);
      game.camera.trackEntity(player, true);
    }

    for (egg in data.l_Entities.all_Egg) {
      eggs.add(new Egg(egg));
    }

    for (bEgg in data.l_Entities.all_BlueEgg) {
      eggs.add(new BlueEgg(bEgg));
    }
    for (bkEgg in data.l_Entities.all_BucketKnight_Egg) {
      eggs.add(new BucketKnightEgg(bkEgg));
    }

    for (sEgg in data.l_Entities.all_Sleether_Egg) {
      eggs.add(new SleetherEgg(sEgg));
    }

    for (rpEgg in data.l_Entities.all_Ropelli802_Egg) {
      eggs.add(new Ropelli802Egg(rpEgg));
    }

    for (oinkEgg in data.l_Entities.all_Oinkster_Egg) {
      eggs.add(new OinksterEgg(oinkEgg));
    }
  }

  public function hasAnyCollision(cx:Int, cy:Int) {
    if ([2, 4].contains(data.l_CollisionLayer.getInt(cx, cy))) {
      return true;
    }
    return false;
  }

  public function getEgg(cx:Int, cy:Int) {
    for (egg in eggs) {
      if (cx == egg.cx && egg.cy == cy && egg.isAlive()) {
        return egg;
      }
    }
    return null;
  }

  public function getCollectible(cx:Int, cy:Int) {
    for (collectible in collectibles) {
      if (cx == collectible.cx && collectible.cy == cy && collectible.isAlive()) {
        return collectible;
      }
    }
    return null;
  }

  public function getEnemyCollision(cx:Int, cy:Int) {
    for (enemy in enemies) {
      if (enemy.cx == cx && enemy.cy == cy && enemy.isAlive()) {
        return enemy;
      }
    }
    return null;
  }

  /**
   * Returns the detection level and the direction
   * to detect in within the game.
   * @param cx 
   * @param cy 
   */
  public function getDetectionLevel(cx:Int, cy:Int, absPos:Point) {
    var detectionLevels = eggs.filter((lEgg) -> lEgg.isAlive()).map((egg) -> {
      var eggAbsPos = egg.spr.localToGlobal();
      {
        pos: new Vector(egg.cx, egg.cy),
        detectionLevel: getEggDetectionLevel(cx, cy, egg),
        dir: new Vector(cx - egg.cx, cy - egg.cy).normalized(),
        ang: M.angTo(absPos.x, absPos.y, eggAbsPos.x, eggAbsPos.y)
      }
    });
    detectionLevels.sort((detectionOne, detectionTwo) -> {
      return detectionTwo.detectionLevel - detectionOne.detectionLevel;
    });

    return detectionLevels.first();
  }

  public function getEggDetectionLevel(cx:Float, cy:Float, egg:BaseEgg) {
    var eggAbsPos = egg.spr.localToGlobal();
    var dist = M.dist(cx, cy, egg.cx, egg.cy);

    var level = switch (dist) {
      case d if (d <= 2):
        DetectionLevel.SuperHot;

      case d if (d <= 5):
        DetectionLevel.Hot;

      case d if (d <= 10):
        DetectionLevel.Warmer;
      case d if (d <= 15):
        DetectionLevel.Warm;
      case d if (d <= 20):
        DetectionLevel.Cold;
      case d if (d <= 25):
        DetectionLevel.IceCold;

      case _:
        DetectionLevel.IceCold;
    }
    egg.visibleShader.visiblePerc = level / SuperHot;
    // var filter:VisibilityFilter = cast egg.spr.filter;
    // filter.setVisiblePerc(level / SuperHot);

    return level;
  }

  override function update() {
    super.update();
    if (player != null) {
      handlePause();
      handleGameOver();
    }
  }

  /**
   * Handles pausing the game
   */
  public function handlePause() {
    if (game.ca.isKeyboardPressed(K.ESCAPE)) {
      Assets.pauseIn.play();
      this.pause();
      scnPause = new Pause();
    }
  }

  public function handleGameOver() {
    if (player.isDead()) {
      this.pause();
      new GameOver();
    }
  }

  function render() {
    // Placeholder level render

    // Rendering Time
    // World
    var tlG = data.l_AutoLayerLevel.render();
    // Decorations
    data.l_Decoration.render(tlG);
    root.addChild(tlG);
    // root.removeChildren();
  }

  override function postUpdate() {
    super.postUpdate();

    if (invalidated) {
      invalidated = false;
      render();
    }
  }

  override function onDispose() {
    super.onDispose();
    // Entity Clean Up on Level dispose
    this.player = null;

    for (collectible in collectibles) {
      collectible.destroy();
    }
  }
}