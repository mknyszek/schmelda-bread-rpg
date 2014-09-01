package main.mickny.schmelda.util;

import openfl.events.KeyboardEvent;
	
class KeyChecker
{
	public static inline var BACKSPACE:Int = 8;
	public static inline var ENTER:Int = 13;
	public static inline var SHIFT:Int = 16;
	public static inline var CTRL:Int = 17;
	public static inline var ALT:Int = 18;
	public static inline var CAPSLOCK:Int = 20;
	public static inline var ESCAPE:Int = 27;
	public static inline var SPACE:Int = 32;
	public static inline var LEFT:Int = 37;
	public static inline var UP:Int = 38;
	public static inline var RIGHT:Int = 39;
	public static inline var DOWN:Int = 40;
	public static inline var A:Int = 65;
	public static inline var D:Int = 68;
	public static inline var S:Int = 83;
	public static inline var W:Int = 87;
	public static inline var X:Int = 88;
	public static inline var Z:Int = 90;
	
	private var keys:Array<Array<Bool>>;
	
	public function new()
	{
		keys = new Array<Array<Bool>>();
		init();
	}
	
	public function init():Void
	{
		var f:Int = 0;
		while(f < 222)
		{
			keys[f] = new Array<Bool>();
			keys[f][0] = false;
			keys[f][1] = false;
			f++;
		}
	}
		
	public function pressed(key:Int):Bool
	{
		if(keys[key][0] == true)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
		
	public function justPressed(key:Int):Bool
	{
		if(keys[key][0] == true && keys[key][1] == false)
		{
			keys[key][1] = true;
			return true;
		}
		else
		{
			return false;
		}
	}
	
	public function released(key:Int):Bool
	{
		if(keys[key][0] == true)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	public function releasedSet(set:Array<Int>):Bool
	{
		for (key in set)
		{
			if(keys[key][0] == true)
			{
				return false;
			}
		}
		
		return true;
	}
	
	public function addKey(e:KeyboardEvent):Void
	{
		keys[e.keyCode][0] = true;
	}
		
	public function removeKey(e:KeyboardEvent):Void
	{
		keys[e.keyCode][0] = false;
		keys[e.keyCode][1] = false;
	}
}	