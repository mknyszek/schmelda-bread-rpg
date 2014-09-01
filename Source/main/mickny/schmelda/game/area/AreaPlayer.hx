package main.mickny.schmelda.game.area;

import main.mickny.schmelda.data.GameData;
import main.mickny.schmelda.util.KeyChecker;
import main.mickny.schmelda.util.GameUtil;
import main.mickny.schmelda.util.animation.AnimatedSprite;
import main.mickny.schmelda.util.animation.Animation;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;

class AreaPlayer extends AnimatedSprite
{
	public var active:Bool;
	
	private var vX:Int;
	private var vY:Int;
	private var speed:Int;
	
	private var bmp:Bitmap;
	
	private var leftX:Int;
	private var rightX:Int;
	private var downY:Int;
	private var upY:Int;
	private var intX:Int;
	private var intY:Int;
	
	private var bl:Bool;
	private var tl:Bool;
	private var br:Bool;
	private var tr:Bool;
	
	private var facing:Int; //1 = down, 2 = left, 3 = up, 4 = right
	
	private var walkSide:Animation;
	private var walkForward:Animation;
	private var walkBackward:Animation;
	
	private var map:AreaMap;
	
	public function new(X:Int, Y:Int, Map:AreaMap)
	{
		super(GameData.party[0].getAreaTileSize().wid, GameData.party[0].getAreaTileSize().hei);
		
		init();
		
		this.x = X;
		this.y = Y;
		this.map = Map;
		
		this.display(bmp, 0);
	}
	
	private function init():Void
	{
		vX = 0;
		vY = 0;
		speed = 1;
		active = true;
		
		bmp = GameData.party[0].getAreaImage();
		
		facing = 1; //1 = down, 2 = left, 3 = up, 4 = right
		walkSide = new Animation("walk_side", bmp, [8, 9, 10, 11, 12, 13], 5);
		walkForward = new Animation("walk_for", bmp, [1, 2, 3, 4, 5, 6], 5);
		walkBackward = new Animation("walk_back", bmp, [15, 16, 17, 18, 19, 20], 5);
	}
	
	public function setFacing(dir:Int):Void
	{
		facing = dir;
		if(facing == 1)
		{
			this.display(bmp, 0);
		}
		else if(facing == 3)
		{
			this.display(bmp, 14);
		}
		else if(facing == 2 || facing == 4)
		{
			this.display(bmp, 7);
		}
	}
	
	public function getFacing():Int
	{
		return facing;
	}
	
	public function update():Void
	{
		this.x += vX;
		this.y += vY;
		
		intX = Std.int(this.x);
		intY = Std.int(this.y);
		
		if(GameUtil.key.pressed(KeyChecker.LEFT) && !toCollide(intX - speed - 1, intY, map, 2))
		{
			vX = -speed;
		}
		else if(GameUtil.key.pressed(KeyChecker.RIGHT) && !toCollide(intX + speed + 1, intY, map, 4))
		{
			vX = speed;
		}
		else
		{
			vX = 0;
			
			//For more accurate collisions, probably won't be needed.
			/*if(toCollide(this.x - 1, this.y, map, "l"))
			{
				this.x += 1;
			}
			else if(toCollide(this.x + 1, this.y, map, "r"))
			{
				this.x -= 1;
			}*/
		}
		
		if(GameUtil.key.pressed(KeyChecker.UP) && !toCollide(intX, intY - speed - 1, map, 3))
		{
			vY = -speed;
		}
		else if(GameUtil.key.pressed(KeyChecker.DOWN) && !toCollide(intX, intY + speed + 1, map, 1))
		{
			vY = speed;
		}
		else
		{
			vY = 0;
			
			//For more accurate collisions, probably won't be needed.
			/*if(toCollide(this.x, this.y - 1, map, "u"))
			{
				this.y += 1;
			}
			else if(toCollide(this.x, this.y + 1, map, "d"))
			{
				this.y -= 1;
			}*/
		}
		
		updateAnimation();
		
		if(GameUtil.key.pressed(KeyChecker.X))
		{
			speed = 2;
		}
		else
		{
			speed = 1;
		}
		
		return;
	}
	
	public function moveToward(x:Int, y:Int):Bool
	{
		this.x += vX;
		this.y += vY;
		
		if (this.x > x)
		{
			vX = -1;
		}
		else if (this.x < x)
		{
			vX = 1;
		}
		else
		{
			vX = 0;
		}
		
		if (this.y > y)
		{
			vY = -1;
		}
		else if (this.y < y)
		{
			vY = 1;
		}
		else
		{
			vY = 0;
		}
		
		updateAnimation();
		
		if (this.x != x || this.y != y)
		{
			return false;
		}
		else
		{
			vX = 0;
			vY = 0;
			return true;
		}
	}
	
	private function toCollide(fx:Int, fy:Int, map:AreaMap, dir:Int):Bool
	{
		/*
		 * 1 = DOWN
		 * 2 = LEFT
		 * 3 = UP
		 * 4 = RIGHT
		*/
		switch(dir)
		{
			case 1:
				leftX = (fx-5) >> 4;
				rightX = (fx+4) >> 4;
				downY = (fy) >> 4;
				bl = collision(leftX, downY, map);
				br = collision(rightX, downY, map);
				return bl || br;
			case 2:
				leftX = (fx-5) >> 4;
				upY = (fy-5) >> 4;
				downY = (fy) >> 4;
				bl = collision(leftX, downY, map);
				tl = collision(leftX, upY, map);
				return bl || tl;
			case 3:
				leftX = (fx-5) >> 4;
				rightX = (fx+4) >> 4;
				upY = (fy-9) >> 4;
				tl = collision(leftX, upY, map);
				tr = collision(rightX, upY, map);
				return tl || tr;
			case 4:
				rightX = (fx+4) >> 4;
				upY = (fy-9) >> 4;
				downY = (fy) >> 4;
				br = collision(rightX, downY, map);
				tr = collision(rightX, upY, map);
				return br || tr;
			default:
				return false;
		}
	}
	
	private function collision(blockX:Int, blockY:Int, map:AreaMap):Bool
	{
		if(blockY < 0 || blockY >= map.getMapHeight() || blockX < 0 || blockX >= map.getMapWidth())
		{
			return false;
		}
		else
		{
			if(map.getTileValue(blockX, blockY) != 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
	
	private inline function updateAnimation():Void
	{
		if(facing == 4)
		{
			this.scaleX = -1;
		}
		else 
		{
			this.scaleX = 1;
		}
		
		if(vX == 0 && vY == 0)
		{
			if(facing == 1)
			{
				this.display(bmp, 0);
			}
			else if(facing == 3)
			{
				this.display(bmp, 14);
			}
			else if(facing == 2 || facing == 4)
			{
				this.display(bmp, 7);
			}
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
			this.animate(walkSide);
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
			this.animate(walkForward);
		}
		else if(vY > 0 && vX != 0 && facing == 1)
		{
			this.animate(walkForward);
		}
		else if(vY > 0 && vX != 0 && facing == 3)
		{
			facing = 1;
		}
		else if(vY < 0 && vX == 0)
		{
			facing = 3;
			this.animate(walkBackward);
		}
		else if(vY < 0 && vX != 0 && facing == 3)
		{
			this.animate(walkBackward);
		}
		else if(vY < 0 && vX != 0 && facing == 1)
		{
			facing = 3;
		}
		else if(vY != 0 && vX != 0 && (facing == 2 || facing == 4))
		{
			this.animate(walkSide);
		}
	}
}
