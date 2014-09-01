package main.mickny.schmelda.game.screen.util;

import main.mickny.schmelda.util.animation.AnimatedSprite;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class Screen extends Sprite
{
	private var type:String;
	private var _allObjs:Array<AnimatedSprite>;
	private var _cam:Camera2D;
	
	public function new(type:String)
	{
		super();
		this.type = type;
		_allObjs = new Array<AnimatedSprite>();
		_cam = new Camera2D(0, 0);
	}
	
	private function update(e:Event):Void
	{}
	
	//Comparator function for sorting by y values.
	private function compareY(fir:AnimatedSprite, sec:AnimatedSprite):Int
	{
		if (fir.y < sec.y)
		{
			return -1;
		}
		else if (fir.y > sec.y)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
}