package main.mickny.schmelda.game.area;

import haxe.Log;
import main.mickny.schmelda.util.GameUtil;
import main.mickny.schmelda.util.KeyChecker;
import main.mickny.schmelda.data.MapObjectData;
import main.mickny.schmelda.data.ScriptData;
import main.mickny.schmelda.game.screen.AreaScreen;
import main.mickny.schmelda.util.animation.AnimatedSprite;
import main.mickny.schmelda.util.animation.Animation;

import openfl.display.Bitmap;
import openfl.geom.Rectangle;

//import cpp.Random;

class AreaNPC extends AreaObject
{
	public var named:String;
	public var say:Array<String>;
	public var fWalk:Animation;
	public var sWalk:Animation;
	public var bWalk:Animation;
	public var still:Animation;
	public var plus:Int;
	public var lplus:Int;
	public var choose:Int;
	
	private var animated:Bool;
	private var intW:Int;
	private var intH:Int;
	private var command:Array<String>;
	private var args:Array<String>;
	
	public function new(named:String, bmp:Bitmap, animated:Bool, startx:Int, starty:Int, map:String, tileWidth:Int, tileHeight:Int)
	{
		super(bmp, tileWidth, tileHeight);
		
		this.named = named;
		this.animated = animated;
		this.x = startx << 4;
		this.y = starty << 4;
		this.intW = Std.int(this.width);
		this.intH = Std.int(this.height);
		this.say = ScriptData.getScriptForObject(map, named);
		
		this.display(this.bmp, 0);
		this.plus = 0;
		this.lplus = 0;
		//this.rgen(5);
		choose = 3;
	}
	
	public override function update(parent:AreaScreen, player:AreaPlayer):Void
	{
		super.update(parent, player);
		
		if(say.length != 0 && hitPlayer == true && GameUtil.key.justPressed(KeyChecker.Z))
		{
			parent.toTextMode(this);
		}
		
		if (this.animated == true)
		{
			switch(choose)
			{				
				//walk right
				case 0:
					this.animate(sWalk);
					this.scaleX = -1;
					this.x += .5;
				//walk left
				case 1:
					this.animate(sWalk);
					this.scaleX = 1;
					this.x -= .5;
				//walk forward
				case 2:
					this.animate(fWalk);
					this.scaleX = 1;
					this.y += .5;
				//walk backwards
				case 3:
					this.animate(bWalk);
					this.scaleX = 1;
					this.y -= .5;	
				//stand still
				case 4:
					this.animate(still);
			}
		}
		else
		{
			this.animate(still);
		}
	}
	
	public function pluser()
	{
		plus++;
	}
	
	public function resetplus()
	{
		plus = 0;
		lplus++;
	}
	
	public function resetlplus()
	{
		lplus = 0;
	}
	
	public function rgen(num:Int)
	{
		var rtime = Date.now().getSeconds();
		var ttime = Std.string(rtime);
		var stime = Std.parseInt(ttime);
		var gen = stime % num;
		choose = gen;	
	}
}


