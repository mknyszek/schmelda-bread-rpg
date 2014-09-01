package main.mickny.schmelda.game.battle;

import main.mickny.schmelda.data.GameData;
import main.mickny.schmelda.data.ScriptData;
import main.mickny.schmelda.game.battle.data.Character;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.GradientType;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFormat;

class BattleCharDisplay extends Sprite
{
	private var hpsta:Bitmap;
	private var hpBar:Sprite;
	private var hpBack:Sprite;
	private var staBar:Sprite;
	private var staBack:Sprite;
	private var backBack1:Sprite;
	private var backBack2:Sprite;
	private var nameField:TextField;
	private var shadowField:TextField;
	private var charIndex:Int;
	
	public function new(charIndex:Int) 
	{
		super();
		
		this.charIndex = charIndex;
		hpsta = new Bitmap(Assets.getBitmapData("assets/img/ui/battle/hpsta.png"));
		backBack1 = new Sprite();
		backBack2 = new Sprite();
		hpBar = new Sprite();
		hpBack = new Sprite();
		staBar = new Sprite();
		staBack = new Sprite();
		
		hpBack.graphics.beginFill(0x000000);
		hpBack.graphics.drawRect(0, 0, 200, 7);
		hpBack.x = -1 * hpBack.width;
		hpBack.y = 0;
		
		staBack.graphics.beginFill(0x000000);
		staBack.graphics.drawRect(0, 0, 200, 7);
		staBack.x = -1 * hpBack.width;
		staBack.y = hpBack.height + 1;
		
		backBack1.graphics.beginFill(0x000000);
		backBack1.graphics.drawRect(0, 0, 200, 7);
		backBack1.x = -1 * hpBack.width + 1;
		backBack1.y = 1;
		
		backBack2.graphics.beginFill(0x000000);
		backBack2.graphics.drawRect(0, 0, 200, 7);
		backBack2.x = -1 * hpBack.width + 1;
		backBack2.y = hpBack.height + 2;
		
		var colorMatrix:Matrix = new Matrix();
		colorMatrix.createGradientBox(200, 7, (Math.PI / 180) * 90, 0, 00);
		
		hpBar.graphics.beginGradientFill(GradientType.LINEAR, [0x64AD45, 0x3D7231], [1.0, 1.0], [0, 255], colorMatrix);
		hpBar.graphics.drawRect(0, 0, Std.int(200 * (GameData.party[charIndex].getCurrentHP() / GameData.party[charIndex].getMaxHP())), 7);
		hpBar.graphics.endFill();
		hpBar.x = hpBack.x;
		hpBar.y = hpBack.y;
		
		staBar.graphics.beginGradientFill(GradientType.LINEAR, [0xFFEE11, 0xAFA349], [1.0, 1.0], [0, 255], colorMatrix);
		staBar.graphics.drawRect(0, 0, Std.int(200 * (GameData.party[charIndex].getCurrentStamina() / Character.MAX_STAMINA)), 7);
		staBar.graphics.endFill();
		staBar.x = staBack.x;
		staBar.y = staBack.y;
		
		hpsta.x = hpBack.x - hpsta.width - 1;
		hpsta.y = hpBack.y;
		
		nameField = new TextField();
		nameField.defaultTextFormat = ScriptData.getHUDFormat();
		nameField.selectable = false;
		nameField.text = GameData.party[charIndex].getName();
		nameField.embedFonts = true;
		nameField.width = 100;
		nameField.height = 18;
		nameField.x = hpsta.x - nameField.width - 2;
		nameField.y = -2;
		
		shadowField = new TextField();
		shadowField.defaultTextFormat = ScriptData.getHUDShadowFormat();
		shadowField.selectable = false;
		shadowField.text = GameData.party[charIndex].getName();
		shadowField.embedFonts = true;
		shadowField.width = 100;
		shadowField.height = 18;
		shadowField.x = hpsta.x - shadowField.width - 1;
		shadowField.y = -1;
		
		this.addChild(backBack1);
		this.addChild(backBack2);
		this.addChild(hpBack);
		this.addChild(staBack);
		this.addChild(hpBar);
		this.addChild(staBar);
		this.addChild(hpsta);
		this.addChild(shadowField);
		this.addChild(nameField);
	}
	
	public function update():Void
	{
		hpBar.width = Std.int(200 * (GameData.party[charIndex].getCurrentHP() / GameData.party[charIndex].getMaxHP()));
		staBar.width = Std.int(200 * (GameData.party[charIndex].getCurrentStamina() / Character.MAX_STAMINA));
	}
}