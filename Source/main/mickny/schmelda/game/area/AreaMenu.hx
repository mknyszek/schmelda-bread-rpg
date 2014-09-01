package main.mickny.schmelda.game.area;

import main.mickny.schmelda.data.GameData;
import main.mickny.schmelda.data.ScriptData;
import main.mickny.schmelda.game.battle.data.Character;
import main.mickny.schmelda.util.animation.AnimatedSprite;
import openfl.display.BitmapData;
import main.mickny.schmelda.util.GameUtil;
import main.mickny.schmelda.util.KeyChecker;
import openfl.Assets;
import openfl.display.GradientType;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.geom.Matrix;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class AreaMenu extends Sprite
{
	private var ent_finish:Bool;
	private var in_use:Bool;
	private var alpha_inc:Float;
	private var panel_main:Bitmap;
	private var panel_nav:Bitmap;
	private var panel_select:Array<Bitmap>;
	
	private var select_inv:Bool;
	private var inv_name_display:TextField;
	private var inv_desc_display:TextField;
	private var inv_desc_sep:Bitmap;
	private var inv_count_display:Array<TextField>;
	private var inv_selector:Bitmap;
	private var inv_position:Int;
	
	private var char_layout:Bitmap;
	private var hp_num:TextField;
	private var hp_bar:Sprite;
	private var prim_stats:Array<TextField>;
	private var battle_stats:Array<TextField>;
	private var name_field:TextField;
	private var stat_xp_bars:Array<Sprite>;
	
	private var char_selector:Bitmap;
	private var char_position:Int;
	private var partyIcons:Array<AnimatedSprite>;
	
	public var finished:Bool;
	
	public function new(X:Float, Y:Float) 
	{
		super();
		this.x = X;
		this.y = Y;
		this.graphics.beginFill(0x121212, 0.2);
		this.graphics.drawRect(0, 0, GameUtil.scrnWidth / GameUtil.ZOOM, GameUtil.scrnHeight / GameUtil.ZOOM);
		this.alpha = 0;
		alpha_inc = 0.05;
		ent_finish = false;
		in_use = false;
		finished = false;
		
		setupPanels();
	}
	
	public function update():Void
	{
		if (!ent_finish)
		{
			this.alpha += alpha_inc;
			alpha_inc += 0.03;
			if (this.alpha >= 1)
			{
				this.alpha = 1;
				ent_finish = true;
				in_use = true;
			}
		}
		else if(in_use)
		{
			if (GameUtil.key.justPressed(KeyChecker.LEFT))
			{
				if (select_inv)
				{
					if (inv_position > 0)
					{
						inv_position--;
						inv_selector.x = panel_nav.x + 102 + inv_position * 28;
						inv_name_display.text = GameData.smallInventory[inv_position].getName();
						inv_desc_display.text = GameData.smallInventory[inv_position].getDescription();
					}
					else
					{
						toChar(partyIcons.length - 1);
					}
				}
				else
				{
					resetPartyIcons();
					if (char_position > 0)
					{
						char_position--;
						char_selector.x = panel_nav.x + 6 + char_position * 32;
					}
					else
					{
						toInv(GameData.smallInventory.length - 1);
					}
				}
			}
			
			if (GameUtil.key.justPressed(KeyChecker.RIGHT))
			{
				if (select_inv)
				{
					if (inv_position < GameData.smallInventory.length - 1)
					{
						inv_position++;
						inv_selector.x = panel_nav.x + 102 + inv_position * 28;
						inv_name_display.text = GameData.smallInventory[inv_position].getName();
						inv_desc_display.text = GameData.smallInventory[inv_position].getDescription();
					}
					else
					{
						toChar(0);
					}
				}
				else
				{
					resetPartyIcons();
					if (char_position < partyIcons.length - 1)
					{
						char_position++;
						char_selector.x = panel_nav.x + 6 + char_position * 32;
					}
					else
					{
						toInv(0);
					}
				}
				
				
			}
			
			if (GameUtil.key.justPressed(KeyChecker.BACKSPACE))
			{
				in_use = false;
			}
			
			if (!select_inv)
			{
				partyIcons[char_position].animate(GameData.party[char_position].getAreaMoveAnimations()[0]);
			}
		}
		else
		{
			this.alpha -= alpha_inc;
			alpha_inc -= 0.03;
			if (this.alpha <= 0)
			{
				finished = true;
			}
		}
	}
	
	private function toInv(pos:Int):Void
	{
		select_inv = true;
		inv_position = pos;
		inv_selector.x = panel_nav.x + 102 + inv_position * 28;
		inv_name_display.text = GameData.smallInventory[inv_position].getName();
		inv_desc_display.text = GameData.smallInventory[inv_position].getDescription();
		name_field.text = "";
		hp_num.text = "";
		
		for (txt in prim_stats)
		{
			txt.text = "";
		}
		
		for (txt in battle_stats)
		{
			txt.text = "";
		}
		
		for (bar in stat_xp_bars)
		{
			bar.visible = false;
		}
		
		inv_desc_sep.visible = select_inv;
		inv_selector.visible = select_inv;
		char_selector.visible = !select_inv;
		char_layout.visible = !select_inv;
		hp_bar.visible = !select_inv;
	}
	
	private function toChar(pos:Int):Void
	{
		select_inv = false;
		inv_name_display.text = "";
		inv_desc_display.text = "";
		name_field.text = GameData.party[char_position].getName();
		hp_num.text = Std.string(GameData.party[char_position].getCurrentHP()) + "/" + Std.string(GameData.party[char_position].getMaxHP());
		char_position = pos;
		char_selector.x = panel_nav.x + 6 + char_position * 32;
		GameData.party[char_position].setTextFieldsForPrim(prim_stats);
		GameData.party[char_position].setTextFieldsForBattle(battle_stats);
		GameData.party[char_position].setXPBarWidths(stat_xp_bars);
		
		for (txt in battle_stats)
		{
			txt.setTextFormat(new TextFormat(null, null, 0x00CCCC), 0, txt.text.length);
		}
		
		inv_desc_sep.visible = select_inv;
		inv_selector.visible = select_inv;
		char_selector.visible = !select_inv;
		char_layout.visible = !select_inv;
		hp_bar.visible = !select_inv;
		
		for (bar in stat_xp_bars)
		{
			bar.visible = true;
		}
	}
	
	private inline function setupPanels():Void
	{
		panel_main = new Bitmap(Assets.getBitmapData("assets/img/ui/pause/main_panel.png"));
		panel_main.x = this.width / 2 - panel_main.width / 2;
		panel_main.y = 8;
		this.addChild(panel_main);
		
		panel_nav = new Bitmap(Assets.getBitmapData("assets/img/ui/pause/nav_panel.png"));
		panel_nav.x = this.width / 2 - panel_nav.width / 2;
		panel_nav.y = panel_main.y + panel_main.height;
		
		inv_name_display = new TextField();
		inv_name_display.defaultTextFormat = ScriptData.getFormat();
		inv_name_display.embedFonts = true;
		inv_name_display.selectable = false;
		inv_name_display.multiline = false;
		inv_name_display.width = 320;
		inv_name_display.height = 22;
		
		inv_desc_display = new TextField();
		inv_desc_display.defaultTextFormat = ScriptData.getFormat();
		inv_desc_display.embedFonts = true;
		inv_desc_display.selectable = false;
		inv_desc_display.multiline = true;
		inv_desc_display.wordWrap = true;
		inv_desc_display.width = 320;
		inv_desc_display.height = 42;
		
		inv_name_display.x = panel_main.x + 6;
		inv_name_display.y = panel_main.y + panel_main.height - inv_name_display.height - inv_desc_display.height;
		inv_desc_display.x = inv_name_display.x;
		inv_desc_display.y = inv_name_display.y + inv_name_display.height - 4;
		
		inv_desc_sep = new Bitmap(Assets.getBitmapData("assets/img/ui/pause/top_slide.png"));
		inv_desc_sep.x = panel_main.x;
		inv_desc_sep.y = inv_name_display.y - inv_desc_sep.height;
		
		this.addChild(inv_name_display);
		this.addChild(inv_desc_display);
		this.addChild(panel_nav);
		this.addChild(inv_desc_sep);
		
		partyIcons = new Array<AnimatedSprite>();
		
		var i:Int = 0;
		for (char in GameData.party)
		{
			if (i == 3)
			{
				break;
			}
			
			partyIcons[i] = new AnimatedSprite(char.getAreaTileSize().wid, char.getAreaTileSize().hei);
			partyIcons[i].display(char.getAreaImage(), char.getAreaIdleFrames()[0]);
			partyIcons[i].x = panel_nav.x + 20 + 32 * i;
			partyIcons[i].y = panel_nav.y + 26 + Math.floor(partyIcons[i].height / 2);
			this.addChild(partyIcons[i]);
			
			i++;
		}
		
		inv_count_display = new Array<TextField>();
		
		i = 0;
		for (item in GameData.smallInventory)
		{
			var bmp:Bitmap = item.getIcon();
			bmp.x = panel_nav.x + 102 + i * 28;
			bmp.y = panel_nav.y + 6;
			this.addChild(bmp);
			i++;
			
			var text:TextField = new TextField();
			text.defaultTextFormat = ScriptData.getFormat();
			text.embedFonts = true;
			text.selectable = false;
			text.multiline = false;
			text.width = 28;
			text.height = 18;
			text.x = bmp.x - 2;
			text.y = bmp.y + 24;
			text.text = "x"+Std.string(item.getAmount());
			inv_count_display.push(text);
			this.addChild(text);
		}
		
		inv_selector = new Bitmap(new BitmapData(24, 24, true, 0x33FFFFFF));
		inv_selector.x = panel_nav.x + 102;
		inv_selector.y = panel_nav.y + 6;
		this.addChild(inv_selector);
		
		select_inv = true;
		inv_position = 0;
		if (GameData.smallInventory.length != 0)
		{
			inv_name_display.text = GameData.smallInventory[inv_position].getName();
			inv_desc_display.text = GameData.smallInventory[inv_position].getDescription();
		}
		
		char_selector = new Bitmap(new BitmapData(28, 43, true, 0x33FFDDDD));
		char_selector.x = panel_nav.x + 6;
		char_selector.y = panel_nav.y + 6;
		this.addChild(char_selector);
		
		char_selector.visible = false;
		char_position = 0;
		
		char_layout = new Bitmap(Assets.getBitmapData("assets/img/ui/pause/char_layout.png"));
		char_layout.x = panel_main.x;
		char_layout.y = panel_main.y;
		char_layout.visible = false;
		this.addChild(char_layout);
		
		name_field = new TextField();
		name_field.selectable = false;
		name_field.embedFonts = true;
		name_field.defaultTextFormat = ScriptData.getDoubleFormat();
		name_field.width = 100;
		name_field.height = 40;
		name_field.x = panel_main.x + 6;
		name_field.y = panel_main.y + panel_main.height - name_field.height;
		this.addChild(name_field);
		
		hp_num = new TextField();
		hp_num.selectable = false;
		hp_num.embedFonts = true;
		hp_num.defaultTextFormat = ScriptData.getRightFormat();
		hp_num.width = 100;
		hp_num.height = 20;
		hp_num.x = panel_main.x + 53;
		hp_num.y = panel_main.y + panel_main.height - hp_num.height - 68;
		this.addChild(hp_num);
		
		hp_bar = new Sprite();
		var colorMatrix:Matrix = new Matrix();
		colorMatrix.createGradientBox(100, 7, (Math.PI / 180) * 90, 0, 00);
		hp_bar.graphics.beginGradientFill(GradientType.LINEAR, [0x64AD45, 0x3D7231], [1.0, 1.0], [0, 255], colorMatrix);
		hp_bar.graphics.drawRect(0, 0, 100, 7);
		hp_bar.graphics.endFill();
		hp_bar.x = hp_num.x + hp_num.width - hp_bar.width - 2;
		hp_bar.y = hp_num.y + hp_num.height - 1;
		hp_bar.width = 100 * (GameData.party[char_position].getCurrentHP() / GameData.party[char_position].getMaxHP());
		hp_bar.visible = false;
		this.addChild(hp_bar);
		
		stat_xp_bars = new Array<Sprite>();
		var colorMatrix:Matrix = new Matrix();
		colorMatrix.createGradientBox(84, 14, (Math.PI / 180) * 90, 0, 00);
		for (i in 0...6)
		{
			var bar:Sprite = new Sprite();
			bar.graphics.beginGradientFill(GradientType.LINEAR, [0xBD0000, 0x741111], [1.0, 1.0], [0, 255], colorMatrix);
			bar.graphics.drawRect(0, 0, 84, 14);
			bar.graphics.endFill();
			bar.x = panel_main.x + panel_main.width - bar.width - 10;
			bar.y = panel_main.y + 8 + i * 21;
			bar.visible = false;
			stat_xp_bars.push(bar);
			this.addChild(bar);
		}
		
		prim_stats = new Array<TextField>();
		for (i in 0...6)
		{
			var txt:TextField = new TextField();
			txt.defaultTextFormat = ScriptData.getCenterFormat();
			txt.selectable = false;
			txt.width = 88;
			txt.height = 20;
			txt.x = panel_main.x + panel_main.width - 95;
			txt.y = panel_main.y + 5 + i * 21;
			prim_stats.push(txt);
			this.addChild(txt);
		}
		
		battle_stats = new Array<TextField>();
		for (i in 0...4)
		{
			var txt:TextField = new TextField();
			txt.defaultTextFormat = ScriptData.getRightFormat();
			txt.selectable = false;
			txt.width = 50;
			txt.height = 20;
			txt.x = panel_main.x + panel_main.width - 56;
			txt.y = panel_main.y + panel_main.height - 88 + i * 21;
			battle_stats.push(txt);
			this.addChild(txt);
		}
	}
	
	private function resetPartyIcons():Void
	{
		var i:Int = 0;
		for (icon in partyIcons)
		{
			icon.display(GameData.party[i].getAreaImage(), GameData.party[i].getAreaIdleFrames()[0]);
			i++;
		}
	}
}