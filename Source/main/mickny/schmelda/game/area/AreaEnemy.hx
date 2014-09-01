package main.mickny.schmelda.game.area;

import main.mickny.schmelda.game.screen.AreaScreen;
import main.mickny.schmelda.util.animation.AnimatedSprite;
import main.mickny.schmelda.util.animation.Animation;
import main.mickny.schmelda.util.Dimension;

import openfl.display.Bitmap;

class AreaEnemy extends AreaObject
{
	public var walk:Animation;
	public var idle:Animation;
	public var attack:Animation;
	public var id:String;
	public var area:Int;
	public var battleReady:Bool;
	public var facing:Int;
	
	private var command:Array<String>;
	private var paused:Bool;
	private var cmdPos:Int;
	private var currState:String;
	private var aggro:Bool;
	private var args:Array<String>;
	private var timer:Int;
	private var spd:Int;
	private var aggroMode:Bool;
	
	public function new(id:String, area:Int, startx:Int, starty:Int, command:String, aggro:Bool, bmp:Bitmap, tileSize:Dimension) 
	{
		super(bmp, tileSize.wid, tileSize.hei);
		
		paused = false;
		cmdPos = 0;
		args = new Array<String>();
		timer = -1;
		
		this.command = command.split(", ");
		this.x = startx << 4;
		this.y = starty << 4;
		this.aggro = aggro;
		this.display(bmp, 1);
		this.id = id;
		this.area = area;
		this.battleReady = false;
		this.facing = 0;
	}
	
	public override function update(parent:AreaScreen, player:AreaPlayer):Void
	{
		super.update(parent, player);
		if (aggroMode == false)
		{
			currState = command[cmdPos].charAt(0);
			
			if (currState == "m")
			{
				this.animate(walk);
				
				if (timer == -1)
				{
					args = command[cmdPos].split(" ");
					timer = Std.parseInt(args[3]);
					spd = Std.int((Std.parseInt(args[2]) << 4) / timer);
				}
				else if (timer == 0)
				{
					timer = -1;
					cmdPos++;
					if (cmdPos == command.length)
					{
						cmdPos = 0;
					}
				}
				else
				{
					timer--;
				}
				
				switch (args[1])
				{
					case "l":
						this.x -= spd;
						this.scaleX = 1;
						facing = 2;
					case "r":
						this.x += spd;
						this.scaleX = -1;
						facing = 4;
					case "u":
						this.y -= spd;
						facing = 3;
					case "d":
						this.y += spd;
						facing = 1;
					case "lu":
						this.x -= spd;
						this.y -= spd;
						this.scaleX = 1;
						facing = 2;
					case "ld":
						this.x -= spd;
						this.y += spd;
						this.scaleX = 1;
						facing = 2;
					case "ru":
						this.x += spd;
						this.y -= spd;
						this.scaleX = -1;
						facing = 4;
					case "rd":
						this.x += spd;
						this.y += spd;
						this.scaleX = -1;
						facing = 4;
				}
			}
			else if (currState == "p")
			{
				this.animate(idle);
				
				if (timer == -1)
				{
					args = command[cmdPos].split(" ");
					timer = Std.parseInt(args[1]);
				}
				else if (timer == 0)
				{
					timer = -1;
					cmdPos++;
					if (cmdPos == command.length)
					{
						cmdPos = 0;
					}
				}
				else
				{
					timer--;
				}
			}
		}
		#if !flash
		if (this.hitTestSprite(player))
		{
			parent.toBattleTransition(this.area);
		}
		#else
		if (this.hitTestObject(player))
		{
			parent.toBattleTransition(this.area);
		}
		#end
	}
	
	public function moveToward(x:Int, y:Int):Bool
	{
		this.animate(walk);
		
		if (this.x > x)
		{
			this.x -= 1;
			this.scaleX = 1;
			
		}
		else if (this.x < x)
		{
			this.x += 1;
			this.scaleX = -1;
		}
		
		if (this.y > y)
		{
			this.y -= 1;
		}
		else if (this.y < y)
		{
			this.y += 1;
		}
		
		if (this.x != x || this.y != y)
		{
			return false;
		}
		else
		{
			this.animate(idle);
			return true;
		}
	}
	
	public function getID():String
	{
		return id;
	}
}