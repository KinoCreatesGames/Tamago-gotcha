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

  public var data:LDTkProj_Level;

  // Groups & Player
  public var player:Player;
  public var collectibles:Group<Collectible>;

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
  }

  public function createEntities() {
    for (pl in data.l_Entities.all_Player) {
      player = new Player(pl.cx, pl.cy);
    }

    for (bkEgg in data.l_Entities.all_BucketKnight_Egg) {
      collectibles.add(new BucketKnightEgg(bkEgg));
    }

    for (sEgg in data.l_Entities.all_Sleether_Egg) {
      collectibles.add(new SleetherEgg(sEgg));
    }

    for (rpEgg in data.l_Entities.all_Ropelli802_Egg) {
      collectibles.add(new Ropelli802Egg(rpEgg));
    }

    for (oinkEgg in data.l_Entities.all_Oinkster_Egg) {
      collectibles.add(new OinksterEgg(oinkEgg));
    }
  }

  public function hasAnyCollision(cx:Int, cy:Int) {
    if ([2, 4].contains(data.l_LevelIGrid.getInt(cx, cy))) {
      return true;
    }
    return false;
  }

  public function getCollectible(cx:Int, cy:Int) {
    return null;
  }

  function render() {
    // Placeholder level render
    root.removeChildren();
    for (cx in 0...cWid)
      for (cy in 0...cHei) {
        var g = new h2d.Graphics(root);
        if (cx == 0
          || cy == 0
          || cx == cWid - 1
          || cy == cHei - 1) g.beginFill(0xffcc00); else
          g.beginFill(Color.randomColor(rnd(0, 1), 0.5, 0.4));
        g.drawRect(cx * Const.GRID, cy * Const.GRID, Const.GRID, Const.GRID);
      }
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