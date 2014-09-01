package main.mickny.schmelda.util;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.system.Capabilities;

import main.mickny.schmelda.game.area.AreaPlayer;
import main.mickny.schmelda.game.screen.util.Camera2D;
import main.mickny.schmelda.util.animation.AnimatedSprite;
import main.mickny.schmelda.game.Game;
import main.mickny.schmelda.game.screen.util.Screen;
	
class GameUtil
{
	public static inline var ZOOM:Int = 2;
	
	public static var key:KeyChecker;
	public static var fullscreen:Bool;
	public static var scrnWidth:Int;
	public static var scrnHeight:Int;
	public static var fps:FPSDisplay;
	public static var aspectRatio:Float;
	
	public static function init():Void
	{
		key = new KeyChecker();
		fullscreen = false;
		scrnWidth = 800;
		scrnHeight = 600;
		aspectRatio = 16 / 9;
	}
	
	public static function scroll(Obj:AnimatedSprite, Cam:Camera2D, LBound:Int, RBound:Int, TBound:Int, DBound:Int, followX:Bool, followY:Bool):Void
	{
		var w:Int = Std.int(scrnWidth / (2*ZOOM));
		var h:Int = Std.int(scrnHeight / (2*ZOOM));
		if(followX)
		{
			if(Obj.x > LBound + w && Obj.x < RBound - w)
			{
				Cam.x = Obj.x - w;
			}
			else if(Obj.x <= LBound + w)
			{
				Cam.x = LBound;
			}
			else if(Obj.x >= RBound - w)
			{
				Cam.x = RBound - 2*w;
			}
		}
		
		if(followY)
		{
			if(Obj.y > TBound + h && Obj.y < DBound - h)
			{
				Cam.y = Obj.y - h;
			}
			else if(Obj.y <= TBound + h)
			{
				Cam.y = TBound;
			}
			else if(Obj.y >= DBound - h)
			{
				Cam.y = DBound - 2*h;
			}
		}
	}
	
	public static function getClosestRectSide(x:Float, y:Float, rect:Rectangle):Int
	{
		var distances:Array<Float> = new Array<Float>();
		
		distances[0] = getDistance(x, y, rect.x + rect.width / 2, rect.top); //top
		distances[1] = getDistance(x, y, rect.x + rect.width / 2, rect.bottom); //bottom
		distances[2] = getDistance(x, y, rect.left, rect.y + rect.height / 2); //left
		distances[3] = getDistance(x, y, rect.right, rect.y + rect.height / 2); //right
		
		var min:Float = distances[0];
		
		for (dist in distances)
		{
			if (dist < min)
			{
				min = dist;
			}
		}
		
		if (min == distances[0]) {
			return 3;
		} else if(min == distances[1]) {
			return 1;
		} else if(min == distances[2]) {
			return 2;
		} else if(min == distances[3]) {
			return 4;
		} else {
			return 1;
		}
	}
	
	public static inline function getDistance(fx:Float, fy:Float, px:Float, py:Float):Float
	{
		return Math.sqrt(Math.pow(fx - px, 2) + Math.pow(fy - py, 2));
	}
	
	public static function stringToArray(x:String):Array<Int>
	{
		var out:Array<Int> = new Array<Int>();
		var temp:Array<String> = new Array<String>();
		var i:Int = 0;
		temp = x.split(", ");
		
		for (str in temp)
		{
			out[i] = Std.parseInt(str);
			i++;
		}
		
		return out;
	}
}