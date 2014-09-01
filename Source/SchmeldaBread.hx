package ;

import main.mickny.schmelda.data.BattleData;
import main.mickny.schmelda.data.CharacterData;
import main.mickny.schmelda.data.GameData;
import main.mickny.schmelda.data.EnemyData;
import main.mickny.schmelda.data.ItemData;
import main.mickny.schmelda.data.MapData;
import main.mickny.schmelda.data.MapObjectData;
import main.mickny.schmelda.data.ScriptData;
import main.mickny.schmelda.game.Game;
import main.mickny.schmelda.game.screen.AreaScreen;
import main.mickny.schmelda.util.GameUtil;
import openfl.display.StageDisplayState;
import openfl.display.StageScaleMode;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.ui.Mouse;

class SchmeldaBread extends Game
{
	public function new()
	{		
		//Initializations
		Mouse.hide();
		GameUtil.init();
		MapData.init();
		MapObjectData.init();
		ScriptData.init();
		ItemData.init();
		BattleData.init();
		EnemyData.init();
		CharacterData.init();
		GameData.init();
		
		//Global utils
		#if !flash
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, glbl_ctrl);
		#end
		Lib.current.stage.scaleMode = StageScaleMode.SHOW_ALL;
		//Startup
		super(new AreaScreen("map1"));
	}
	
	#if !flash
	public function glbl_ctrl(e:KeyboardEvent):Void
	{
		switch(e.keyCode)
		{
			case 27:
				Lib.close();
			case 123:
				if (GameUtil.fullscreen)
				{
					GameUtil.fullscreen = false;
					GameUtil.scrnWidth = 800;
					Lib.current.stage.displayState = StageDisplayState.NORMAL;
				}
				else
				{
					GameUtil.fullscreen = true;
					
					if (GameUtil.aspectRatio == 16 / 9)
					{
						GameUtil.scrnWidth = 1067;
					}
					else if (GameUtil.aspectRatio == 16 / 10)
					{
						GameUtil.scrnWidth = 960;
					}
					
					Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				}
		}
	}
	#end
	
	public static function main()
	{
		Lib.current.addChild(new SchmeldaBread());
	}
}