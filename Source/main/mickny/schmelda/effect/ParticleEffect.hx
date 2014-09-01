package main.mickny.schmelda.effect;

import flash.display.BitmapData;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.Lib;

class Effect extends Bitmap
{
	private var particles:Array<Particle>;
	private var particleImg:BitmapData;
	
	public function new()
	{
		super(new BitmapData(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, true, 0));
		
		//particleImg = Assets.getBitmapData();
	}
}

class Particle
{
	public var x:Int;
	public var y:Int;
	public var frame:Int;
	
	public function new(initX:Int, initY:Int, initFrame:Int)
	{
		
	}
}