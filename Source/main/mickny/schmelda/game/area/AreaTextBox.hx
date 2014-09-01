package main.mickny.schmelda.game.area;

import main.mickny.schmelda.util.GameUtil;
import main.mickny.schmelda.util.KeyChecker;
import main.mickny.schmelda.data.ScriptData;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

class AreaTextBox extends Sprite
{
	public static inline var DELAY:Int = 3;
	
	private var bg_bmp:Bitmap;
	private var txt_con:TextField;
	private var txt_full:Array<String>;
	private var light_chars:List<Int>;
	private var txt_in:String;
	private var txt_who:String;
	private var pos:Int;
	private var page:Int;
	private var maxPages:Int;
	private var spkrLen:Int;
	private var format:TextFormat;
	private var highlight:TextFormat;
	private var ent_finish:Bool;
	private var in_use:Bool;
	private var alpha_inc:Float;
	
	public var disp_time:Int;
	public var finished:Bool;
	
	public function new(X:Float, Y:Float, Speaker:String, Text:Array<String>)
	{
		super();
		
		finished = false;
		pos = 0;
		bg_bmp = new Bitmap(Assets.getBitmapData("assets/img/ui/txtbox_small.png"));
		format = ScriptData.getFormat();
		ent_finish = false;
		in_use = false;
		alpha_inc = 0.05;
		
		this.addChild(bg_bmp);
		
		txt_who = Speaker;
		txt_full = Text;
		page = 0;
		maxPages = txt_full.length;
		txt_in = txt_full[page];
		light_chars = new List<Int>();
		spkrLen = Speaker.length + 2;
		
		txt_con = new TextField();
		txt_con.defaultTextFormat = format;
		txt_con.embedFonts = true;
		txt_con.border = false;
		txt_con.selectable = false;
		txt_con.multiline = true;
		txt_con.wordWrap = true;
		txt_con.width = 364;
		txt_con.height = 92;
		txt_con.x = 8;
		txt_con.y = 6;
		
		txt_con.text += txt_who + ": ";
		
		if(txt_in.charAt(0) == "." || txt_in.charAt(0) == ",")
		{
			disp_time = DELAY*2;
		}
		else
		{
			disp_time = DELAY;
		}
		
		resetLightChars();
		
		this.addChild(txt_con);
		
		this.x = X;
		this.y = Y;
		this.alpha = 0;
	}
	
	public function update():Void
	{
		if (!ent_finish)
		{
			this.alpha += alpha_inc;
			alpha_inc += 0.04;
			if (this.alpha >= 1)
			{
				this.alpha = 1;
				ent_finish = true;
				in_use = true;
			}
		}
		else if(in_use)
		{
			disp_time--;
			if(disp_time <= 0)
			{
				displayText();
			}
			
			if (GameUtil.key.justPressed(KeyChecker.Z))
			{
				if (page == 0)
				{
					txt_con.text = txt_who + ": " + txt_in;
					for (i in light_chars) txt_con.setTextFormat(new TextFormat(null, null, 0x983131), i + spkrLen, txt_in.indexOf(" ", i) + spkrLen);
				}
				else
				{
					txt_con.text = txt_in;
					for (i in light_chars) txt_con.setTextFormat(new TextFormat(null, null, 0x983131), i+spkrLen, txt_in.indexOf(" ", i)+spkrLen);
				}
				
				pos = txt_in.length;
			}
		}
		else
		{
			this.alpha -= alpha_inc;
			alpha_inc -= 0.04;
			if (this.alpha <= 0)
			{
				finished = true;
			}
		}
	}
	
	private function resetLightChars():Void
	{
		light_chars.clear();
		var i:Int = 0;
		while (i < txt_in.length)
		{
			if (txt_in.charAt(i) == "`")
			{
				light_chars.add(i);
				txt_in = txt_in.substr(0, i) + txt_in.substr(i + 1);
			}
			i++;
		}
	}
	
	private function displayText():Void
	{
		if(pos != txt_in.length)
		{
			txt_con.appendText(txt_in.charAt(pos));
			
			if(txt_in.charAt(pos) == "." || txt_in.charAt(pos) == ",")
			{
				disp_time = DELAY*4;
			}
			else
			{
				disp_time = DELAY;
			}
			
			pos++;
			
			for (i in light_chars)
			{
				if (i < pos)
				{
					if (txt_in.indexOf(" ", i) + spkrLen < txt_con.text.length)
					{
						txt_con.setTextFormat(new TextFormat(null, null, 0x983131), i + spkrLen, txt_in.indexOf(" ", i) + spkrLen);
					}
					else
					{
						txt_con.setTextFormat(new TextFormat(null, null, 0x983131), i + spkrLen, txt_con.text.length);
					}
				}
			}
		}
		else
		{
			if(GameUtil.key.justPressed(KeyChecker.Z))
			{
				txt_con.text = "";
				pos = 0;
				
				if (page == maxPages-1)
				{
					in_use = false;
				}
				else
				{
					page++;
					spkrLen = 0;
					txt_in = txt_full[page];
					resetLightChars();
				}
			}
		}
	}
}