package en;

import en.collectibles.BucketKnightEgg;
import en.collectibles.Ropelli802Egg;
import en.collectibles.SleetherEgg;
import en.collectibles.OinksterEgg;
import en.collectibles.Egg;
import en.collectibles.BlueEgg;
import h3d.Vector;
import dn.legacy.Controller.ControllerAccess;

class Player extends BaseEnt {
  public var ct:ControllerAccess;
  public var listener:EventListener<Player>;

  public static inline var INVINCIBLE_TIME:Float = 3;

  public static inline var MOVE_SPD:Float = .1;
  public static inline var JUMP_FORCE:Float = 1;

  public var isInvincible(get, null):Bool;

  public var detectionLevel:GameTypes.DetectionLevel;
  public var detectionDir:Vector;
  public var detectionAngle:Float;

  public var eggIndicator:h2d.Graphics;

  public inline function get_isInvincible() {
    return cd.has('invincibleTime');
  }

  public function new(x:Int, y:Int) {
    super(x, y);

    setup();
  }

  public function setup() {
    ct = Main.ME.controller.createAccess('player');
    listener = EventListener.create();

    setupStats();
    setupGraphic();
  }

  public function setupStats() {
    this.health = 3;
  }

  public function setupGraphic() {
    var g = this.spr.createGraphics();
    var size = 16;
    g.beginFill(0xffff00);
    g.drawRect(0, 0, size, size);
    g.endFill();
    g.y -= 8;
    g.x -= 8;
    setupIndicator();
  }

  public function setupIndicator() {
    eggIndicator = spr.createGraphics();
    var tile = hxd.Res.img.Egg_indicator.toTile();
    eggIndicator.beginTileFill(tile);
    eggIndicator.drawRect(0, 0, Const.GRID, Const.GRID);
    eggIndicator.endFill();
  }

  override function onPreStepX() {
    super.onPreStepX();

    if (level.hasAnyCollision(cx + 1,
      cy - 1) && xr >= 0.7) // Handle squash and stretch for entities in the game
    {
      xr = 0.5;
      dx = 0;
      setSquashY(0.6);
    }

    if (level.hasAnyCollision(cx - 1, cy - 1) && xr <= 0.3) {
      xr = 0.3;
      dx = 0;
      setSquashY(0.6);
    }
  }

  override function onPreStepY() {
    super.onPreStepY();

    if (level.hasAnyCollision(cx, cy)
      && yr >= 0.5
      || level.hasAnyCollision(cx + M.round(xr), cy)
      && yr >= 0.5) {
      // Handle squash and stretch for entities in the game
      if (level.hasAnyCollision(cx, cy + M.round(yr + 0.3))) {
        // setSquashY(0.6);
        dy = 0;
      }
      yr = 0.5;
      dy = 0;
    }
  }

  override function update() {
    super.update();
    updateInvincibility();
    handleMovement();
    updateCollisions();
    updateDetection();
  }

  /**
   * Updates the invincibility of the sprite
   * using the blinking capability.
   */
  public function updateInvincibility() {
    if (isInvincible) {
      // spr.alpha = 1;
      if (!cd.has('invincible')) {
        cd.setF('invincible', 5, () -> {
          spr.alpha = 0;
        });
      } else {
        spr.alpha = 1;
      }
    } else {
      spr.alpha = 1;
    }
  }

  public function handleMovement() {
    var left = ct.leftDown();
    var right = ct.rightDown();
    var up = ct.upDown();
    var down = ct.downDown();

    if (left || right || up || down) {
      if (left) {
        dx = -MOVE_SPD;
      } else if (right) {
        dx = MOVE_SPD;
      }

      if (up) {
        dy = -MOVE_SPD;
      } else if (down) {
        dy = MOVE_SPD;
      }
    }
  }

  public function updateCollisions() {
    if (level != null) {
      if (this.isAlive()) {
        collideWithCollectible();
        collideWithEnemy();
      }
      collideWithExit();
    }
  }

  /**
   * Handle enemy collisions within the game.
   */
  public function collideWithEnemy() {
    var enemy = level.getEnemyCollision(cx, cy);
    if (enemy != null) {
      takeDamage();
    }
  }

  public function collideWithCollectible() {
    collideWithEgg();
  }

  public function collideWithEgg() {
    var egg = level.getEgg(cx, cy);
    if (egg != null) {
      var eggType = Type.getClass(egg);
      switch (eggType) {
        case OinksterEgg:
        // Handle Oinkster Egg
        case BucketKnightEgg:
        // Handle BucketKnight Egg
        case Ropelli802Egg:
        // Handle Ropelli802 Egg
        case SleetherEgg:
        // SleetherEgg
        case en.collectibles.Egg:
          if (xr > .5 && xr < .7) {
            trace(xr);
            Assets.collectSnd.play();
            egg.destroy();
          }
        case en.collectibles.BlueEgg:
          if (xr > .5 && xr < .7) {
            trace(xr);
            Assets.collectSnd.play();
            egg.destroy();
          }
        case _:
      }
    }
  }

  /**
   * Updates the detection area
   * for the egg over time.
   */
  public function updateDetection() {
    var detection = level.getDetectionLevel(cx, cy);
    if (detection != null) {
      detectionLevel = detection.detectionLevel;
      detectionDir = detection.dir;
      detectionAngle = detection.ang;
    }
  }

  /**
   * Complete level the second you get to the exit.
   */
  public function collideWithExit() {
    game.completeLevel();
  }

  override function takeDamage(value:Int = 1) {
    // Shake camera when the player takes damage.
    if (!isInvincible) {
      Game.ME.camera.shakeS(0.5, 0.5);
      super.takeDamage(value);
      cd.setS('invincibleTime', INVINCIBLE_TIME);
      this.knockback();
      // Play Damage Sound
      Assets.damageSnd.play();
    }
  }
}