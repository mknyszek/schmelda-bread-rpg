package main.mickny.schmelda.data;

import main.mickny.schmelda.game.area.AreaPlayer;
import main.mickny.schmelda.game.battle.BattleEnemy;
import main.mickny.schmelda.game.battle.BattlePlayer;
import main.mickny.schmelda.game.battle.data.Ability;
import main.mickny.schmelda.util.animation.Animation;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class BattleData
{
	//Holds Character Map and Images for Battle. All enemies handled in EnemyData.hx
	
	//Visual Button Image Data, 0 = available, 1 = down, 2 = grayed out
	public static var atk:Array<BitmapData>;
	public static var df:Array<BitmapData>;
	public static var it:Array<BitmapData>;
	public static var mv:Array<BitmapData>;
	public static var tc:Array<BitmapData>;
	public static var pla_ind:Array<BitmapData>;
	
	public static function init():Void
	{
		atk = new Array<BitmapData>();
		atk[0] = Assets.getBitmapData("assets/img/ui/battle/atkbtn.png");
		atk[1] = Assets.getBitmapData("assets/img/ui/battle/atkbtn_down.png");
		atk[2] = Assets.getBitmapData("assets/img/ui/battle/atkbtn_gray.png");
		
		df = new Array<BitmapData>();
		df[0] = Assets.getBitmapData("assets/img/ui/battle/dfbtn.png");
		df[1] = Assets.getBitmapData("assets/img/ui/battle/dfbtn_down.png");
		df[2] = Assets.getBitmapData("assets/img/ui/battle/dfbtn_gray.png");
		
		it = new Array<BitmapData>();
		it[0] = Assets.getBitmapData("assets/img/ui/battle/itbtn.png");
		it[1] = Assets.getBitmapData("assets/img/ui/battle/itbtn_down.png");
		it[2] = Assets.getBitmapData("assets/img/ui/battle/itbtn_gray.png");
		
		mv = new Array<BitmapData>();
		mv[0] = Assets.getBitmapData("assets/img/ui/battle/mvbtn.png");
		mv[1] = Assets.getBitmapData("assets/img/ui/battle/mvbtn_down.png");
		mv[2] = Assets.getBitmapData("assets/img/ui/battle/mvbtn_gray.png");
		
		tc = new Array<BitmapData>();
		tc[0] = Assets.getBitmapData("assets/img/ui/battle/tcbtn.png");
		tc[1] = Assets.getBitmapData("assets/img/ui/battle/tcbtn_down.png");
		tc[2] = Assets.getBitmapData("assets/img/ui/battle/tcbtn_gray.png");
		
		pla_ind = new Array<BitmapData>();
		pla_ind[0] = Assets.getBitmapData("assets/img/ui/battle/up_select.png");
		pla_ind[1] = Assets.getBitmapData("assets/img/ui/battle/left_select.png");
		pla_ind[2] = Assets.getBitmapData("assets/img/ui/battle/right_select.png");
	}
	
	public static function getPlayerBattleData(pla:AreaPlayer):BattlePlayer
	{
		var out:BattlePlayer = new BattlePlayer(pla.x, pla.y + GameData.party[0].getBattleTileYOffset(), pla.getFacing(), 0, 
			GameData.party[0].getBattleImage(), GameData.party[0].getBattleTileSize());
		
		out.start = new Array<Animation>();
		out.start[0] = new Animation("startForward", out.getImage(), [0, 1, 2], 5, false);
		out.start[1] = new Animation("startSide", out.getImage(), [38, 39, 40], 5, false);
		out.start[2] = new Animation("startBackward", out.getImage(), [19, 20, 21], 5, false);
		
		out.idle = new Array<Animation>();
		out.idle[0] = new Animation("idleForward", out.getImage(), [3, 4, 3, 5], 10);
		out.idle[1] = new Animation("idleSide", out.getImage(), [41, 42, 41, 43], 10);
		out.idle[2] = new Animation("idleBackward", out.getImage(), [22, 23, 22, 24], 10);
		
		out.move = new Array<Animation>();
		out.move[0] = new Animation("moveForward", out.getImage(), [6, 7, 8, 9, 10, 11], 5);
		out.move[1] = new Animation("moveSide", out.getImage(), [44, 45, 46, 47, 48, 49], 5);
		out.move[2] = new Animation("moveBackward", out.getImage(), [25, 26, 27, 28, 29, 30], 5);
		
		out.attack1 = new Array<Animation>();
		out.attack1[0] = new Animation("attackForward1", out.getImage(), [12, 13, 14], 10, false);
		out.attack1[1] = new Animation("attackSide1", out.getImage(), [50, 51, 52], 10, false);
		out.attack1[2] = new Animation("attackBackward1", out.getImage(), [31, 32, 33], 10, false);
		
		out.attack2 = new Array<Animation>();
		out.attack2[0] = new Animation("attackForward2", out.getImage(), [15, 16], 10, false);
		out.attack2[1] = new Animation("attackSide2", out.getImage(), [53, 54], 10, false);
		out.attack2[2] = new Animation("attackBackward2", out.getImage(), [34, 35], 10, false);
		
		out.defend = new Array<Animation>();
		out.defend[0] = new Animation("defendForward", out.getImage(), [17], 5, false);
		out.defend[1] = new Animation("defendSide", out.getImage(), [55], 5, false);
		out.defend[2] = new Animation("defendBackward", out.getImage(), [36], 5, false);
		
		out.useItem = new Array<Animation>();
		out.useItem[0] = new Animation("useItemForward", out.getImage(), [18], 5, false);
		out.useItem[1] = new Animation("useItemSide", out.getImage(), [56], 5, false);
		out.useItem[2] = new Animation("useItemBackward", out.getImage(), [37], 5, false);
		
		out.initAnimation();
		
		return out;
	}
	
	//public static function getCharacterBattleData(char:AreaCharacter):BattlePlayer
}