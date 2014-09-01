package main.mickny.schmelda.game.battle;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import main.mickny.schmelda.util.animation.AnimatedSprite;

class Selector extends Sprite
{
	private var tl:Bitmap;
	private var tr:Bitmap;
	private var bl:Bitmap;
	private var br:Bitmap;
	private var target:AnimatedSprite;
	
	public function new(target:AnimatedSprite) 
	{
		super();
		
		tl = new Bitmap(Assets.getBitmapData("assets/img/ui/battle/select_topleft.png"));
		tr = new Bitmap(Assets.getBitmapData("assets/img/ui/battle/select_topright.png"));
		bl = new Bitmap(Assets.getBitmapData("assets/img/ui/battle/select_bottomleft.png"));
		br = new Bitmap(Assets.getBitmapData("assets/img/ui/battle/select_bottomright.png"));
		
		changeTarget(target);
		
		this.addChild(tl);
		this.addChild(tr);
		this.addChild(bl);
		this.addChild(br);
	}
	
	public function update():Void
	{
		this.x = target.x;
		this.y = target.y;
	}
	
	public inline function changeTarget(target:AnimatedSprite):Void
	{
		tl.x = Math.floor(-1 * target.width / 2);
		tl.y = Math.floor(-1 * target.height);
		tr.x = Math.floor(target.width / 2);
		tr.y = Math.floor(-1 * target.height);
		bl.x = Math.floor(-1 * target.width / 2);
		bl.y = 0;
		br.x = Math.floor(target.width / 2);
		br.y = 0;
		
		this.target = target;
		this.x = target.x;
		this.y = target.y;
	}
}