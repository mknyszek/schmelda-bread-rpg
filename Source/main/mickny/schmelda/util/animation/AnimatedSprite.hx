package main.mickny.schmelda.util.animation;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class AnimatedSprite extends Sprite
{
	private var tileWidth:Int; //Each sprite's width.
	private var tileHeight:Int; //Each sprite's height.
	private var bgBitmapData:BitmapData; //Empty bitmapData for clearing bmpHolder.
	private var bmpHolder:Bitmap; //The bitmap which will be displayed, and where stuff will be copied to.
	private var hitRect:Rectangle;
	
	//Variables used for animation.
	private var delayTimer:Int;
	private var curIndex:Int;
	private var maxIndex:Int;
	private var toChange:Bool;
	private var curAnim:String;
	
	public function new(tileWidth:Int, tileHeight:Int)
	{
		super();
		
		delayTimer = 0;
		curIndex = 0;
		toChange = true;
		
		//Pass size of tiles
		this.tileWidth = tileWidth; 
		this.tileHeight = tileHeight;
		
		//Create bmpHolder properly and set its center to the center of the sprite.
		bmpHolder = new Bitmap(new BitmapData(tileWidth, tileHeight, true, 0x000000));
		this.addChild(bmpHolder);
		bmpHolder.x -= tileWidth/2;
		bmpHolder.y -= tileHeight;
		
		//Create empty bitmap data.
		bgBitmapData = new BitmapData(tileWidth, tileHeight, true, 0x000000);
		
		//Create collision rectangle
		hitRect = new Rectangle(this.bmpHolder.x + this.x, this.bmpHolder.y + this.y, tileWidth, tileHeight);
	}
	
	public function display(bmp:Bitmap, index:Int, ?resetAnim:Bool = false):Void //Call to display a particular frame.
	{
		var lineWidth:Int = Std.int(bmp.bitmapData.width / tileWidth);
		var rect:Rectangle = new Rectangle((index % lineWidth) * tileWidth, Math.floor(index / lineWidth) * tileHeight, tileWidth, tileHeight);
		var pt:Point = new Point(0, 0);
		
		if (resetAnim) curAnim = "";
		
		bmpHolder.bitmapData.lock();
		
		clearBitmap(); //Clears bitmap for redrawing.
		bmpHolder.bitmapData.copyPixels(bmp.bitmapData, rect, pt, null, null, true); //Draw next frame
		
		bmpHolder.bitmapData.unlock();
	}
	
	public function displayFromData(bmpData:BitmapData, index:Int):Void //Call to display a particular frame.
	{
		var lineWidth:Int = Std.int(bmpData.width / tileWidth);
		var rect:Rectangle = new Rectangle((index % lineWidth) * tileWidth, Math.floor(index / lineWidth) * tileHeight, tileWidth, tileHeight);
		var pt:Point = new Point(0, 0);
		
		bmpHolder.bitmapData.lock();
		
		clearBitmap(); //Clears bitmap for redrawing.
		bmpHolder.bitmapData.copyPixels(bmpData, rect, pt, null, null, true); //Draw next frame
		
		bmpHolder.bitmapData.unlock();
	}
	
	public function animate(anim:Animation):Bool //Call each frame to animate certain frames in the order listed in the array in the Animation object.
	{
		if(anim.name != curAnim)
		{
			curIndex = 0;
			maxIndex = anim.animList.length-1;
			delayTimer = anim.delay;
			toChange = true;
			curAnim = anim.name;
		}
		
		if(toChange == true)
		{
			display(anim.bmp, anim.animList[curIndex]);
			toChange = false;
		}
		
		if(curIndex == maxIndex)
		{
			if (anim.loop)
			{
				curIndex = -1;
			}
			else
			{
				curIndex = maxIndex;
			}
		}
		
		delayTimer--;
		if(delayTimer <= 0)
		{
			if (!anim.loop && curIndex == maxIndex)
			{
				return true;
			}
			else
			{
				curIndex++;
				delayTimer = anim.delay;
				toChange = true;
			}
		}
		return false;
	}
	
	public function getBitmap():Bitmap
	{
		return bmpHolder;
	}
	
	public function getHitRect():Rectangle
	{
		hitRect.x = this.bmpHolder.x + this.x;
		hitRect.y = this.bmpHolder.y + this.y;
		return hitRect;
	}
	
	private inline function clearBitmap():Void
	{
		bmpHolder.bitmapData.copyPixels(bgBitmapData, bgBitmapData.rect, new Point(0, 0));
	}
	
	#if !flash
	public function hitTestSprite(as:AnimatedSprite):Bool
	{
		return this.getHitRect().intersects(as.getHitRect());
	}
	#end
}