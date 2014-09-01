package main.mickny.schmelda.game.battle.data;

import main.mickny.schmelda.util.animation.AnimatedSprite;
import main.mickny.schmelda.util.animation.Animation;
import openfl.display.Bitmap;

class BattleEntity extends AnimatedSprite
{
	public var active:Bool;
	public var dead:Bool;
	
	private var state:String;
	private var facing:Int;
	private var vX:Int;
	private var vY:Int;
	private var bmp:Bitmap;
	
	public function new(tileWidth:Int, tileHeight:Int, facing:Int, bmp:Bitmap)
	{
		super(tileWidth, tileHeight);
		
		active = true;
		dead = false;
		state = "start";
		vX = 0;
		vY = 0;
		this.bmp = bmp;
		this.facing = facing;
	}
	
	public function setState(state:String):Void
	{
		this.state = state;
	}
	
	public function getFacing():Int
	{
		return facing;
	}
	
	public function takeDamage(rawDamage:Int, ?ignoreDefense:Bool = false, ?ranged:Bool = false):Void {}
	
	public function faceToward(x:Float, y:Float)
	{
		var f:Float = Math.atan2(this.y - y, this.x - x);
		f *= 180 / Math.PI;
		if (f >= 45 && f < 135)
		{
			facing = 3;
		}
		else if (f >= -135 && f < -45)
		{
			facing = 1;
		}
		else if ((f >= -45 && f < 0) || (f < 45 && f >= 0))
		{
			facing = 2;
		}
		else if ((f >= -135 && f <= 180) || (f < -135 && f > -180))
		{
			facing = 4;
		}
	}
	
	private function facingToAnimation(arr:Array<Animation>):Animation
	{
		if (arr.length != 4)
		{
			if (facing != 4)
			{
				this.scaleX = 1;
				return arr[facing - 1];
			}
			else
			{
				this.scaleX = -1;
				return arr[1];
			}
		}
		else
		{
			return arr[facing - 1];
		}
	}
	
	private inline function updateMovementAnimation(idle:Array<Animation>, move:Array<Animation>):Void
	{
		if(vX == 0 && vY == 0)
		{
			this.animate(facingToAnimation(idle));
		}
		else if(vX != 0 && vY == 0)
		{
			if(vX > 0)
			{
				facing = 4;
			}
			else if(vX < 0)
			{
				facing = 2;
			}
			this.animate(facingToAnimation(move));
		}
		else if(vY != 0 && vX > 0 && facing == 2)
		{
			facing = 4;
		}
		else if(vY != 0 && vX < 0 && facing == 4)
		{
			facing = 2;
		}
		else if(vY > 0 && vX == 0)
		{
			facing = 1;
			this.animate(facingToAnimation(move));
		}
		else if(vY > 0 && vX != 0 && facing == 1)
		{
			this.animate(facingToAnimation(move));
		}
		else if(vY > 0 && vX != 0 && facing == 3)
		{
			facing = 1;
		}
		else if(vY < 0 && vX == 0)
		{
			facing = 3;
			this.animate(facingToAnimation(move));
		}
		else if(vY < 0 && vX != 0 && facing == 3)
		{
			this.animate(facingToAnimation(move));
		}
		else if(vY < 0 && vX != 0 && facing == 1)
		{
			facing = 3;
		}
		else if(vY != 0 && vX != 0 && (facing == 2 || facing == 4))
		{
			this.animate(facingToAnimation(move));
		}
	}
}