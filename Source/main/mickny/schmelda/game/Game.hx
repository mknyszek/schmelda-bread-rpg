package main.mickny.schmelda.game;

import main.mickny.schmelda.util.FPSDisplay;
import main.mickny.schmelda.util.GameUtil;
import main.mickny.schmelda.game.screen.util.Screen;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;

class Game extends Sprite
{
	private var curScreen:Screen;
	
	public function new(firstScreen:Screen)
	{
		super();
		
		openfl.Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, GameUtil.key.addKey);
		openfl.Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, GameUtil.key.removeKey);
		
		curScreen = firstScreen;
		this.addChild(curScreen);
		
		GameUtil.fps = new FPSDisplay();
		GameUtil.fps.x = GameUtil.scrnWidth - 50;
		GameUtil.fps.y = 10;
		this.addChild(GameUtil.fps);
	}
}