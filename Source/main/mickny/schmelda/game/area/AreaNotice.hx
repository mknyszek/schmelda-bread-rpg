package main.mickny.schmelda.game.area;

import main.mickny.schmelda.data.ScriptData;
import main.mickny.schmelda.util.GameUtil;
import main.mickny.schmelda.util.KeyChecker;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.text.TextField;

class AreaNotice extends Sprite
{
	private var bmp:Bitmap;
	private var txt:TextField;
	private var ready:Bool;
	private var end:Bool;
	
	public var finished:Bool;
	
	public function new(msg:String)
	{
		super();
		
		ready = false;
		end = false;
		finished = false;
		
		bmp = new Bitmap(Assets.getBitmapData("assets/img/ui/txtbox_quick.png"));
		this.addChild(bmp);
		
		txt = new TextField();
		txt.defaultTextFormat = ScriptData.getCenterFormat();
		txt.selectable = false;
		txt.embedFonts = true;
		txt.x = 4;
		txt.y = 2;
		txt.width = 232;
		txt.height = 20;
		txt.text = msg;
		this.addChild(txt);
		
		this.alpha = 0;
	}
	
	public function update():Void
	{
		if (!ready && !end)
		{
			this.alpha += 0.1;
			if (this.alpha >= 1)
			{
				this.alpha = 1;
				ready = true;
			}
		}
		else if (!ready && end)
		{
			this.alpha -= 0.1;
			if (this.alpha <= 0)
			{
				this.alpha = 0;
				finished = true;
			}
		}
		else
		{
			if (GameUtil.key.justPressed(KeyChecker.Z))
			{
				ready = false;
				end = true;
			}
		}
	}
}