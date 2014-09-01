package main.mickny.schmelda.game.battle;

import openfl.geom.Rectangle;

class BattleRectangle extends Rectangle
{
	public var active:Bool;
	public var id:Int;

	public function new(active:Bool, id:Int, x:Int, y:Int, width:Int, height:Int)
	{
		super(x, y, width, height);
		this.active = active;
		this.id = id;
	}
}