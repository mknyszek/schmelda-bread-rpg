package main.mickny.schmelda.game.battle;

import main.mickny.schmelda.data.BattleData;
import main.mickny.schmelda.util.animation.AnimatedSprite;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class BattleHUD extends Sprite
{
	private var intWidth:Int;
	private var intHeight:Int;
	
	private var bottomFill:Bitmap;
	private var leftAction:AnimatedSprite;
	private var middleAction:AnimatedSprite;
	private var topAction:AnimatedSprite;
	private var rightAction:AnimatedSprite;
	private var selector:Selector;
	
	private var charInfo:Array<BattleCharDisplay>;
	
	public function new(x:Float, y:Float, camWidth:Int, camHeight:Int, charInfoCount:Int) 
	{
		super();
		
		this.x = x;
		this.y = y;
		
		intWidth = camWidth;
		intHeight = camHeight;
		
		bottomFill = new Bitmap(Assets.getBitmapData("assets/img/ui/battle/battle_ui_fill.png"));
		bottomFill.x = 0;
		bottomFill.y = intHeight - bottomFill.height;
		this.addChild(bottomFill);
		
		//Later to be obtained from character config...
		///////Spans from here.
		leftAction = new AnimatedSprite(25, 25);
		middleAction = new AnimatedSprite(25, 25);
		topAction = new AnimatedSprite(25, 25);
		rightAction = new AnimatedSprite(25, 25);
		
		leftAction.displayFromData(BattleData.atk[0], 0);
		middleAction.displayFromData(BattleData.it[2], 0);
		topAction.displayFromData(BattleData.mv[0], 0);
		rightAction.displayFromData(BattleData.df[0], 0);
		
		leftAction.x = 8 + leftAction.width / 2;
		leftAction.y = intHeight - 8;		
		middleAction.x = leftAction.x + middleAction.width;
		middleAction.y = intHeight - 8;
		topAction.x = middleAction.x;
		topAction.y = intHeight - topAction.height - 8;	
		rightAction.x = middleAction.x + rightAction.width;
		rightAction.y = intHeight - 8;
		///////To here.
		
		this.addChild(leftAction);
		this.addChild(middleAction);
		this.addChild(topAction);
		this.addChild(rightAction);
		
		charInfo = new Array<BattleCharDisplay>();
		
		for (i in 0...charInfoCount)
		{
			charInfo.push(new BattleCharDisplay(i));
			charInfo[i].x = intWidth - 4;
			charInfo[i].y = bottomFill.y + i * (charInfo[i].height + 4) + 8;
			this.addChild(charInfo[i]);
		}
	}
	
	public function update():Void
	{
		for (char in charInfo)
		{
			char.update();
		}
	}
	
	public function setLeftButtonState(i:Int):Void
	{
		if (i > 2 || i < 0) return;
		leftAction.displayFromData(BattleData.atk[i], 0);
	}
	
	public function setDownButtonState(i:Int):Void
	{
		if (i > 2 || i < 0) return;
		middleAction.displayFromData(BattleData.it[i], 0);
	}
	
	public function setRightButtonState(i:Int):Void
	{
		if (i > 2 || i < 0) return;
		rightAction.displayFromData(BattleData.df[i], 0);
	}
	
	public function setUpButtonState(i:Int):Void
	{
		if (i > 2 || i < 0) return;
		topAction.displayFromData(BattleData.mv[i], 0);
	}
}