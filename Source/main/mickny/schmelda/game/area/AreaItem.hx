package main.mickny.schmelda.game.area;

import main.mickny.schmelda.game.screen.AreaScreen;
import main.mickny.schmelda.item.Item;
import main.mickny.schmelda.util.animation.AnimatedSprite;
import main.mickny.schmelda.util.animation.Animation;
import main.mickny.schmelda.util.GameUtil;
import main.mickny.schmelda.util.KeyChecker;
import openfl.Assets;
import openfl.display.Bitmap;

class AreaItem extends AnimatedSprite
{
	private var drop:Bool;
	private var id:Int;
	private var amt:Int;
	private var bmp:Bitmap;
	private var grav:Int;
	private var limit:Int;
	private var spd:Int;
	private var dir:Int;
	
	private var anim:Bool;
	private var delay:Int;
	
	private var sparkle:Animation;
	
	public function new(x:Float, y:Float, id:Int, amt:Int, dir:Int)
	{
		super(12, 12);
		
		bmp = new Bitmap(Assets.getBitmapData("assets/img/item/dropitem.png"));
		grav = 0;
		limit = Math.ceil(Math.random()*4 + 4);
		spd = Math.ceil(Math.random()*2 + 4);
		anim = false;
		delay = 40;
		sparkle = new Animation("sparkle", bmp, [1, 2, 3, 4, 5, 6, 7], 2, false);
		
		this.id = id;
		this.amt = amt;
		this.dir = dir;
		this.x = x;
		this.y = y;
		
		if (dir < 1 || dir > 4) drop = false;
		else drop = true;
		
		this.display(bmp, 0);
	}
	
	public function getItem():Item
	{
		return new Item(id, amt);
	}
	
	public function update(screen:AreaScreen, player:AreaPlayer):Void
	{
		if (drop)
		{
			switch(dir)
			{
				case 1:
					this.y -= spd;
					this.y += grav;
				case 2:
					this.x -= spd;
					this.y += grav;
				case 3:
					this.y += spd;
					this.y -= grav;
				case 4:
					this.x += spd;
					this.y += grav;
			}
			
			grav++;
			
			if (grav == limit)
			{
				grav = -1 * (grav >> 1);
				limit = limit >> 1;
				spd = spd >> 1;
				
				if (limit == 0)
				{
					drop = false;
				}
			}
		}
		else
		{
			if (delay <= 0)
			{
				var done:Bool = this.animate(sparkle);
				if (done)
				{
					delay = Math.ceil(Math.random() * 100 + 100);
					this.display(bmp, 0, true);
				}
			}
			else
			{
				delay--;
			}
			
			#if !flash
			if (this.hitTestSprite(player) && GameUtil.key.justPressed(KeyChecker.Z))
			{
				screen.toItemReceive(this);
			}
			#else
			if (this.hitTestObject(player) && GameUtil.key.justPressed(KeyChecker.Z))
			{
				screen.toItemReceive(this);
			}
			#end
		}
	}
}