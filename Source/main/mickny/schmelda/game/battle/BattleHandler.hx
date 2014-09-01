package main.mickny.schmelda.game.battle;

import main.mickny.schmelda.data.BattleData;
import main.mickny.schmelda.data.EnemyData;
import main.mickny.schmelda.data.MapData;
import main.mickny.schmelda.game.area.AreaEnemy;
import main.mickny.schmelda.game.area.AreaPlayer;
import main.mickny.schmelda.game.battle.data.BattleEntity;
import main.mickny.schmelda.game.screen.AreaScreen;
import main.mickny.schmelda.game.screen.util.Camera2D;
import main.mickny.schmelda.util.GameUtil;
import main.mickny.schmelda.util.KeyChecker;
import openfl.geom.Rectangle;

class BattleHandler 
{
	private static var battleRegions:Array<BattleRectangle>;
	private static var battlePlayers:Array<BattlePlayer>; //Indices can ALWAYS be assumed parallel to GameData.party
	private static var battleEnemies:Array<BattleEnemy>;
	private static var battleQueue:Array<BattleAction>;
	
	private static var finished:Bool;
	private static var selecting:Bool;
	private static var selected:Array<Bool>;
	private static var moveMode:Bool;
	private static var attackMode:Bool;
	private static var movingPlayer:BattlePlayer;
	private static var currentAction:BattleAction;
	private static var actionInProgress:Bool;
	private static var deadEnemy:Int;
	private static var deadPlayer:Int;
	
	private static var selector:Selector;
	private static var selectedEntity:BattleEntity;
	private static var selectIndex:Int;
	private static var selectEnemy:Bool;
	
	public static var battleHUD:BattleHUD;
	
	public static function init(id:String):Void 
	{
		battleRegions = MapData.getBattleRects(id);
		battlePlayers = new Array<BattlePlayer>();
		battleQueue = new Array<BattleAction>();
		battleEnemies = new Array<BattleEnemy>();
		
		selected = new Array<Bool>();
		selected[0] = false;
		selected[1] = false;
		selected[2] = false;
		
		finished = false;
		selecting = false;
		currentAction = null;
		actionInProgress = false;
		deadEnemy = 0;
		deadPlayer = 0;
	}
	
	public static function check(player:AreaPlayer, screen:AreaScreen):Void
	{
		for (rect in battleRegions)
		{
			if (rect.active == true && player.getHitRect().intersects(rect))
			{
				screen.toBattleTransition(rect.id);
			}
		}
	}
	
	public static function update(screen:AreaScreen, area:BattleRectangle):Void
	{
		if (battleQueue.length > 0 && !actionInProgress)
		{
			currentAction = battleQueue.pop();
			currentAction.entity.setState(currentAction.move);
			currentAction.entity.faceToward(currentAction.target.x, currentAction.target.y);
			setEntitiesInactiveExcept(currentAction.entity);
			actionInProgress = true;
		}
		
		if (battleHUD.alpha < 1 && !finished)
		{
			battleHUD.alpha += 0.07;
		}
		
		deadPlayer = 0;
		for (pla in battlePlayers)
		{
			if (pla.active) pla.update();
			if (pla.dead) deadPlayer++;
		}
		
		deadEnemy = 0;
		for (ene in battleEnemies)
		{
			if (ene.active) ene.update(screen, battlePlayers, area);
			if (ene.dead) deadEnemy++;
		}
		
		battleHUD.update();
		selector.update();
		
		if (GameUtil.key.pressed(KeyChecker.W))
		{
			selecting = true;
			battleHUD.setUpButtonState(1);
			
			if (GameUtil.key.justPressed(KeyChecker.W))
			{
				moveMode = false;
				if(movingPlayer != null) movingPlayer.setState("idle");
				battleHUD.setUpButtonState(0);
				
				var i:Int = 0;
				for (pla in battlePlayers)
				{
					pla.showIndicator(BattleData.pla_ind[i]);
					i++;
				}
			}
			
			if (GameUtil.key.justPressed(KeyChecker.UP))
			{
				toMoveMode(battlePlayers[0]);
			}
			else if (GameUtil.key.justPressed(KeyChecker.LEFT) && battlePlayers.length > 1)
			{
				toMoveMode(battlePlayers[1]);
			}
			else if (GameUtil.key.justPressed(KeyChecker.RIGHT) && battlePlayers.length > 2)
			{
				toMoveMode(battlePlayers[2]);
			}
		}
		else if (GameUtil.key.pressed(KeyChecker.A))
		{
			selecting = true;
			attackMode = true;
			battleHUD.setLeftButtonState(1);
			
			if (GameUtil.key.justPressed(KeyChecker.A))
			{
				moveMode = false;
				if(movingPlayer != null) movingPlayer.setState("idle");
				battleHUD.setUpButtonState(0);
				
				var i:Int = 0;
				for (pla in battlePlayers)
				{
					pla.showIndicator(BattleData.pla_ind[i]);
					if(!pla.getRanged()) pla.showRange();
					i++;
				}
			}
			
			if (GameUtil.key.justPressed(KeyChecker.UP))
			{
				selected[0] = true;
				battlePlayers[0].hideIndicator();
				attackMode = true;
			}
			
			if (GameUtil.key.justPressed(KeyChecker.LEFT) && battlePlayers.length > 1)
			{
				selected[1] = true;
				battlePlayers[1].hideIndicator();
				attackMode = true;
			}
			
			if (GameUtil.key.justPressed(KeyChecker.RIGHT) && battlePlayers.length > 2)
			{
				selected[2] = true;
				battlePlayers[2].hideIndicator();
				attackMode = true;
			}
		}
		else if (GameUtil.key.pressed(KeyChecker.D))
		{
			selecting = true;
			attackMode = true;
			battleHUD.setRightButtonState(1);
			
			if (GameUtil.key.justPressed(KeyChecker.D))
			{
				moveMode = false;
				if(movingPlayer != null) movingPlayer.setState("idle");
				battleHUD.setUpButtonState(0);
				
				var i:Int = 0;
				for (pla in battlePlayers)
				{
					pla.showIndicator(BattleData.pla_ind[i]);
					i++;
				}
			}
			
			if (GameUtil.key.justPressed(KeyChecker.UP))
			{
				battlePlayers[0].hideIndicator();
				battlePlayers[0].setState("defend");
			}
			
			if (GameUtil.key.justPressed(KeyChecker.LEFT) && battlePlayers.length > 1)
			{
				battlePlayers[1].hideIndicator();
				battlePlayers[1].setState("defend");
			}
			
			if (GameUtil.key.justPressed(KeyChecker.RIGHT) && battlePlayers.length > 2)
			{
				battlePlayers[2].hideIndicator();
				battlePlayers[2].setState("defend");
			}
		}
		else if (GameUtil.key.justPressed(KeyChecker.LEFT) && !moveMode && !selecting)
		{
			selectIndex--;
			if (selectIndex < 0)
			{
				selectIndex = battleEnemies.length - 1;
			}
			selectedEntity = battleEnemies[selectIndex];
			selector.changeTarget(selectedEntity);
		}
		else if (GameUtil.key.justPressed(KeyChecker.RIGHT) && !moveMode && !selecting)
		{
			selectIndex++;
			if (selectIndex > battleEnemies.length - 1)
			{
				selectEnemy = !selectEnemy;
				selectIndex = 0;
			}
			selectedEntity = battleEnemies[selectIndex];
			selector.changeTarget(selectedEntity);
		}
		else if (selecting == true)
		{
			if (checkAnySelected() && !moveMode)
			{
				if (attackMode)
				{
					var i:Int = 0;
					for (select in selected)
					{
						if (select)
						{
							battlePlayers[i].prepareAttack(selectedEntity);
						}
						i++;
					}
				}
			}
			selecting = false;
			attackMode = false;
			var i:Int = 0;
			for (pla in battlePlayers)
			{
				pla.hideIndicator();
				pla.hideRange();
				selected[i] = false;
				i++;
			}
			battleHUD.setUpButtonState(0);
			battleHUD.setLeftButtonState(0);
			battleHUD.setRightButtonState(0);
		}
		
		if (deadEnemy == battleEnemies.length)
		{
			screen.exitBattle(battlePlayers, battleEnemies); //Destroys battleHUD and selector, which is referenced here... CAREFUL!
		}
	}
	
	public static function getBattleRect(area:Int):BattleRectangle
	{
		for (rect in battleRegions)
		{
			if (rect.id == area)
			{
				return rect;
			}
		}
		return null;
	}
	
	public static function addAndConstructBattleObjects(pla:AreaPlayer, cam:Camera2D, screen:AreaScreen, enemies:Array<AreaEnemy>):Void
	{
		battlePlayers[0] = BattleData.getPlayerBattleData(pla);
		
		for (bp in battlePlayers)
		{
			screen.addChildAt(bp, screen.getChildIndex(pla));
		}
		
		//Assumes at least one enemy.
		var i:Int = 0;
		for (enemy in enemies)
		{
			battleEnemies[i] = EnemyData.getBattleEnemy(enemy.id, enemy.facing, enemy.x, enemy.y);
			screen.addChildAt(battleEnemies[i], screen.getChildIndex(enemy));
			i++;
		}
		
		selectIndex = 0;
		selectEnemy = false;
		selectedEntity = battleEnemies[0];
		selector = new Selector(selectedEntity);
		screen.addChild(selector);
		
		battleHUD = new BattleHUD(cam.x, cam.y, Std.int(cam.width), Std.int(cam.height), battlePlayers.length);
		battleHUD.alpha = 0;
		screen.addChild(battleHUD);
	}
	
	public static function removeAndDestroyBattleObjects(screen:AreaScreen):Void
	{	
		for (bp in battlePlayers)
		{
			screen.removeChild(bp);
		}
		
		battlePlayers[0] = null;
		
		for (enemy in battleEnemies)
		{
			screen.removeChild(enemy);
		}
		
		var i:Int = 0;
		while (i < battleEnemies.length)
		{
			battleEnemies[i] = null;
			i++;
		}
		
		screen.removeChild(selector);
		selector = null;
		
		screen.removeChild(battleHUD);
		battleHUD = null;
	}
	
	public static function addToBattleQueue(x:BattleAction):Void
	{
		battleQueue.unshift(x);
	}
	
	public static function resetActivity():Void
	{
		for (pla in battlePlayers)
		{
			pla.active = true;
		}
		
		for (ene in battleEnemies)
		{
			ene.active = true;
		}
		
		actionInProgress = false;
	}
	
	public static function exitMoveMode():Void
	{
		moveMode = false;
		movingPlayer.setState("idle");
	}
	
	private static function checkAnySelected():Bool
	{
		for (sel in selected)
		{
			if (sel != false)
			{
				return true;
			}
		}
		return false;
	}
	
	private static function toMoveMode(pla:BattlePlayer):Void
	{
		moveMode = true;
		movingPlayer = pla;
		pla.setState("move");
	}
	
	private static function setEntitiesInactiveExcept(en:BattleEntity):Void
	{
		for (pla in battlePlayers)
		{
			if (pla != en) pla.active = false;
		}
		
		for (ene in battleEnemies)
		{
			if (ene != en) ene.active = false;
		}
	}
}