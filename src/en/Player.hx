package en;

import GameTypes.DetectionLevel;
import shaders.DistanceToColor2D;
import h2d.col.Point;
import en.collectibles.BucketKnightEgg;
import en.collectibles.Ropelli802Egg;
import en.collectibles.SleetherEgg;
import en.collectibles.OinksterEgg;
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
  public var eggCount:Int;

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
    var hero = hxd.Res.img.player_character_flat.toAseprite()
      .aseToSlib(Const.FPS);
    spr.set(hero);
    spr.anim.registerStateAnim('forward', 0, () -> {
      return dx == 0 || dy > 0;
    });
    spr.anim.registerStateAnim('right', 1, () -> {
      return dx > 0;
    });
    spr.anim.registerStateAnim('backward', 2, () -> {
      return dy < 0;
    });
    spr.anim.registerStateAnim('left', 3, () -> {
      return dx < 0;
    });
    spr.setCenterRatio();

    setupIndicator();
  }

  public function setupIndicator() {
    eggIndicator = spr.createGraphics();
    var tile = hxd.Res.img.egg_indicator_two.toTile();
    eggIndicator.beginTileFill(tile);
    eggIndicator.drawRect(0, 0, Const.GRID, Const.GRID);
    eggIndicator.endFill();
    eggIndicator.x = -16;
    eggIndicator.y = -32;
    eggIndicator.addShader(new DistanceToColor2D());
  }

  override function onPreStepX() {
    super.onPreStepX();

    if (level.hasAnyCollision(cx + 1,
      cy) && xr >= 0.7) // Handle squash and stretch for entities in the game
    {
      xr = 0.5;
      dx = 0;
      setSquashY(0.6);
    }

    if (level.hasAnyCollision(cx - 1, cy) && xr <= 0.3) {
      xr = 0.3;
      dx = 0;
      setSquashY(0.6);
    }
  }

  override function onPreStepY() {
    super.onPreStepY();

    if (level.hasAnyCollision(cx, cy) && yr >= 0.5) {
      // Handle squash and stretch for entities in the game
      if (level.hasAnyCollision(cx, cy + M.round(yr + 0.3))) {
        // setSquashY(0.6);
        dy = 0;
      }
      yr = 0.5;
      dy = 0;
    }

    if (level.hasAnyCollision(cx, cy - 1) && yr < 0.5) {
      yr = 0.4;
      dy = 0;
    }

    if (level.hasAnyCollision(cx, cy + 1) && yr > 0.5) {
      yr = .5;
      dy = 0;
    }
  }

  override function update() {
    super.update();
    updateIndicator();
    updateInvincibility();
    handleMovement();
    updateCollisions();
  }

  public function updateIndicator() {
    var absPos = spr.absPos();
    var eggDetection = level.getDetectionLevel(cx, cy, absPos);
    var additionalRad = M.toRad(90);
    var radius = 30;
    var startPoint = new Point(1, 0);

    if (eggDetection != null) {
      var eggAng = eggDetection.ang;
      var finalAng = eggAng + additionalRad;
      startPoint.rotate(eggAng);

      eggIndicator.x = -16 + (startPoint.x * radius);
      eggIndicator.y = -20 + (startPoint.y * radius);
      eggIndicator.getShader(DistanceToColor2D)
        .distancePerc = eggDetection.detectionLevel / DetectionLevel.SuperHot;
    }
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
      if (xr > .3 && xr < .9) {
        switch (eggType) {
          case OinksterEgg:
            // Handle Oinkster Egg
            Assets.collectSnd.play();
            level.score += 1000;
            this.eggCount++;
            egg.destroy();
          case BucketKnightEgg:
            // Handle BucketKnight Egg
            Assets.collectSnd.play();
            level.score += 1000;
            this.eggCount++;
            egg.destroy();
          case Ropelli802Egg:
            // Handle Ropelli802 Egg
            Assets.collectSnd.play();
            level.score += 1000;
            this.eggCount++;
            egg.destroy();
          case SleetherEgg:
            // SleetherEgg
            Assets.collectSnd.play();
            level.score += 1000;
            this.eggCount++;
            egg.destroy();
          case en.collectibles.Egg:
            Assets.collectSnd.play();
            this.eggCount++;
            egg.destroy();
            level.score += 100;
          case en.collectibles.BlueEgg:
            Assets.collectSnd.play();
            this.eggCount++;
            egg.destroy();
            level.score += 200;
          case _:
        }
        setSquashY(0.6);
      }
      hud.invalidate();
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