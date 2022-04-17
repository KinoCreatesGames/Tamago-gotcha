import h3d.Vector;

typedef LvlState = {
  playerPos:Vector,
  reachedCheckpoint:Bool,
  checkpointPos:Vector,
  blockPositions:Array<Vector>
}

typedef LvlSave = {
  playerStart:VectorSave,
  blocks:Array<BlockSave>
}

/**
 * Vector Save Stats
 */
typedef VectorSave = {
  x:Int,
  y:Int,
  z:Int
}

/**
 * Block Save Stats
 */
typedef BlockSave = {
  blockType:BlockType,
  pos:VectorSave
}

/**
 * The different types of block
 * available for the user to use within the
 * game.
 */
enum abstract BlockType(String) from String to String {
  var BlockB:String = 'RegularBlock';
  var BounceB:String = 'BounceBlock';
  var CrackedB:String = 'CrackedBlock';
  var IceB:String = 'IceBlock';
  var MysteryB:String = 'MysteryBlock';
  var StaticB:String = 'StaticBlock';
  var SpikeB:String = 'SpikeBlock';
  var GoalB:String = 'GoalBlock';
  var BlackHoleB:String = 'BlackHoleBlock';
  var HeavyB:String = 'HeavyBlock';
}

enum abstract CollectibleTypes(String) from String to String {
  var BambooR = 'BambooRockets';
  var ShardR = 'Shard';
  var CheckpointR = 'Checkpoint';
  var JLife = 'Life';
  var JetPack = 'JetPack';
}

/**
 * Detection level based on how close you 
 * are to the target egg.
 */
enum abstract DetectionLevel(Int) from Int to Int {
  /**
   * 90 - 100 - 2 tiles away
   */
  var SuperHot = 6;

  /**
   * 70-90 - 5 tiles away
   */
  var Hot = 5;

  /**
   * 50 - 70 - 10 tiles away
   */
  var Warmer = 4;

  /**
   * 40 - 50 - 15 tiles away
   */
  var Warm = 3;

  /**
   * 20 - 40 - 20 tiles away
   */
  var Cold = 2;

  /**
   * 0 - 20 - 25 tiles away
   */
  var IceCold = 1;
}