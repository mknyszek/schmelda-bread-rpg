package main.mickny.schmelda.game.area;

import main.mickny.schmelda.game.screen.AreaScreen;
import main.mickny.schmelda.util.animation.AnimatedSprite;

import openfl.display.Bitmap;

class AreaObject extends AnimatedSprite
{
	public var hitPlayer:Bool;
	private var bmp:Bitmap;
	
	public function new(bmp:Bitmap, tileWidth:Int, tileHeight:Int)
	{
		super(tileWidth, tileHeight);
		this.bmp = bmp;
		hitPlayer = false;
	}
	
	public function update(parent:AreaScreen, player:AreaPlayer):Void
	{
		#if flash
		if (this.hitTestObject(player))
		{
			this.hitPlayer = true;
		}
		else
		{
			this.hitPlayer = false;
		}
		#else
		if (this.hitTestSprite(player))
		{
			this.hitPlayer = true;
		}
		else
		{
			this.hitPlayer = false;
		}
		#end
	}
}