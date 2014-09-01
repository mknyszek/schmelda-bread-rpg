package main.mickny.schmelda.util.animation;

import openfl.display.Bitmap;

class Animation
{
	public var name:String;
	public var bmp:Bitmap;
	public var animList:Array<Int>;
	public var delay:Int;
	public var loop:Bool;
	
	public function new(id:String, Dbmp:Bitmap, framesBmp:Array<Int>, delayFrame:Int, ?loopAnim:Bool = true)
	{
		name = id;
		bmp = Dbmp;
		animList = framesBmp;
		delay = delayFrame;
		loop = loopAnim;
	}
}