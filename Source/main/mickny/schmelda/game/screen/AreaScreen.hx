package main.mickny.schmelda.game.screen;

import main.mickny.schmelda.data.GameData;
import main.mickny.schmelda.data.ItemData;
import main.mickny.schmelda.data.MapData;
import main.mickny.schmelda.data.MapObjectData;
import main.mickny.schmelda.game.area.AreaItem;
import main.mickny.schmelda.game.area.AreaMenu;
import main.mickny.schmelda.game.area.AreaNotice;
import main.mickny.schmelda.game.battle.BattleEnemy;
import main.mickny.schmelda.game.battle.BattleHandler;
import main.mickny.schmelda.game.battle.BattleHUD;
import main.mickny.schmelda.game.battle.BattlePlayer;
import main.mickny.schmelda.game.battle.BattleRectangle;
import main.mickny.schmelda.item.Item;
import main.mickny.schmelda.util.GameUtil;
import main.mickny.schmelda.util.KeyChecker;
import main.mickny.schmelda.game.area.AreaMap;
import main.mickny.schmelda.game.area.AreaMapHandler;
import main.mickny.schmelda.game.area.AreaEnemy;
import main.mickny.schmelda.game.area.AreaObject;
import main.mickny.schmelda.game.area.AreaNPC;
import main.mickny.schmelda.game.area.AreaPlayer;
import main.mickny.schmelda.game.area.AreaTextBox;
import main.mickny.schmelda.game.screen.util.Camera2D;
import main.mickny.schmelda.util.animation.AnimatedSprite;
import main.mickny.schmelda.util.Dimension;
import main.mickny.schmelda.game.screen.util.Screen;
import openfl.display.BlendMode;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;

class AreaScreen extends Screen
{
	//General Screen Properties
	private var _active:Bool;
	
	//Modes
	private var _textMode:Bool;
	private var _menuMode:Bool;
	private var _battleMode:Bool;
	private var _itemReceiveMode:Bool;
	
	//Area Objects
	private var _map_ground:AreaMap;
	private var _map_collide:AreaMap;
	private var _map_top:AreaMap;
	private var _player:AreaPlayer;
	private var _text:AreaTextBox;
	private var _menu:AreaMenu;
	private var _quick:AreaNotice;
	private var _map_dim:Dimension;
	private var _npcs:Array<AreaNPC>;
	private var _enemies:Array<AreaEnemy>;
	private var _enemiesToBattle:Array<AreaEnemy>;
	private var _areaItems:Array<AreaItem>;
	
	//Area Transition
	private var _mapTransition:Bool;
	private var _transitionBmp:Bitmap;
	private var _tempPosTrans:Int;
	private var _battleTransition:Bool;
	
	//Battle Objects & Variables
	private var _curBattleRect:BattleRectangle;
	private var _curBattleArea:Int;
	private var _closestRectSide:Int;
	private var _battleCamPosX:Int;
	private var _battleCamPosY:Int;
	
	public function new(MAP:String)
	{
		super("AREA");
		_textMode = false;
		_menuMode = false;
		_itemReceiveMode = false;
		_active = true;
		_tempPosTrans = 0;
		_enemiesToBattle = new Array<AreaEnemy>();
		
		AreaMapHandler.init(MAP);
		BattleHandler.init(MAP);
		
		_map_ground = new AreaMap(MAP, "ground");
		this.addChild(_map_ground);
		
		_map_collide = new AreaMap(MAP, "collide");
		this.addChild(_map_collide);
		
		loadObjects(MAP, 320, 240);
		
		_map_top = new AreaMap(MAP, "top");
		this.addChild(_map_top);
		
		_map_dim = MapData.getMapDimension(MAP);
		
		this.addEventListener(Event.ENTER_FRAME, update);
	}
	
	private override function update(e:Event):Void //Main Screen Loop
	{
		GameUtil.fps.nextFrame();
		if (_active)
		{
			for (item in _areaItems)
			{
				item.update(this, _player);
			}
			
			if(_menuMode) //Menumode stops everything and brings up the in-game menu
			{
				_menu.update();
				
				if (_menu.finished)
				{
					_menuMode = false;
					this.removeChild(_menu);
				}
			}
			else if (_itemReceiveMode) //Stops all text and menus to recieve item
			{
				_quick.update();
				
				if (_quick.finished)
				{
					_itemReceiveMode = false;
					this.removeChild(_quick);
				}
			}
			else if(_textMode) //Textmode stops everything and brings up the dialog box
			{
				_text.update();
				
				if(_text.finished)
				{
					_textMode = false;
					this.removeChild(_text);
				}
			}
			else if (_battleMode)
			{
				BattleHandler.update(this, _curBattleRect);
				updateDepth();
			}
			else
			{	
				_cam.update(this);
				updateDepth();
				
				if (_player.active)
				{
					_player.update();
					
					var toNext:Bool = AreaMapHandler.check(_player, this);
					
					GameUtil.scroll(_player, _cam, 0, _map_dim.wid, 0, _map_dim.hei, true, true);
					if (toNext)
					{
						_cam.update(this);
						return;
					}
				}
				
				for(aObject in _npcs)
				{
					aObject.update(this, _player);
				}
				
				for(aObject in _enemies)
				{
					aObject.update(this, _player);
				}
				
				if(GameUtil.key.justPressed(KeyChecker.BACKSPACE))
				{
					toMenuMode();
					return;
				}
			}
		}
		else //This portion will be occupied by transition code
		{
			if (_battleTransition)
			{
				var camDone:Bool = _cam.moveToward(this, _battleCamPosX, _battleCamPosY);
				var plaDone:Bool;
				var eneDone:Array<Bool> = new Array<Bool>();
				
				switch(_closestRectSide)
				{
					case 1:
						plaDone = _player.moveToward(Std.int(_curBattleRect.x + _curBattleRect.width/2), Std.int(_curBattleRect.bottom));
					case 2:
						plaDone = _player.moveToward(Std.int(_curBattleRect.left), Std.int(_curBattleRect.y + _curBattleRect.height/2));
					case 3:
						plaDone = _player.moveToward(Std.int(_curBattleRect.x + _curBattleRect.width/2), Std.int(_curBattleRect.top));
					case 4:
						plaDone = _player.moveToward(Std.int(_curBattleRect.right), Std.int(_curBattleRect.y + _curBattleRect.height / 2));
					default:
						plaDone = false;
				}
				
				if (plaDone)
				{
					switch(_closestRectSide)
					{
						case 1:
							_player.setFacing(3);
						case 2:
							_player.setFacing(4);
						case 3:
							_player.setFacing(1);
						case 4:
							_player.setFacing(2);
					}
				}
				
				var i:Int = 0;
				for (enemy in _enemies)
				{
					if (enemy.area == _curBattleArea)
					{
						switch(_closestRectSide)
						{
							case 3:
								eneDone[i] = enemy.moveToward(Std.int(_curBattleRect.x + _curBattleRect.width/2), Std.int(_curBattleRect.bottom));
							case 4:
								eneDone[i] = enemy.moveToward(Std.int(_curBattleRect.left), Std.int(_curBattleRect.y + _curBattleRect.height/2));
							case 1:
								eneDone[i] = enemy.moveToward(Std.int(_curBattleRect.x + _curBattleRect.width/2), Std.int(_curBattleRect.top));
							case 2:
								eneDone[i] = enemy.moveToward(Std.int(_curBattleRect.right), Std.int(_curBattleRect.y + _curBattleRect.height/2));
						}
						i++;
					}
				}
				
				if (checkBattleReady(camDone, plaDone, eneDone))
				{
					toBattleMode();
				}
			}
			else if(_mapTransition)
			{
				if (_tempPosTrans == 36)
				{
					this.removeChild(_transitionBmp);
					_active = true;
					_mapTransition = false;
				}
				
				bitmapTransitionEffectIteration();
			}
		}
	}
	
	private function loadObjects(mapName:String, playerX:Int, playerY:Int):Void //init loading object helper
	{
		_npcs = MapObjectData.getAreaNPCArray(mapName);
		_enemies = MapObjectData.getAreaEnemyArray(mapName);
		_areaItems = new Array<AreaItem>();
		_player = new AreaPlayer(playerX, playerY, _map_collide);
		_allObjs.push(_player);
		
		for(aObject in _npcs)
		{
			_allObjs.push(aObject);
		}
		
		for(aObject in _enemies)
		{
			_allObjs.push(aObject);
		}
		
		for (aObject in _areaItems)
		{
			_allObjs.push(aObject);
		}
		
		if (_allObjs.length > 1)
		{
			_allObjs.sort(compareY);
		}
		
		var i:Int = 2;
		for (obj in _allObjs)
		{
			this.addChildAt(obj, i);
			i++;
		}
	}
	
	private function updateDepth():Void
	{
		var i:Int;
		if (_battleMode) i = this.numChildren - 4;
		else i = this.numChildren - 2;
		while (i > 1)
		{
			var flip:Bool = false;
			var j:Int = 0;
			while(j < i)
			{
				if (this.getChildAt(j).y > this.getChildAt(j + 1).y)
				{
					this.swapChildrenAt(j, j+1);
					flip = true;
				}
				j++;
			}
			if (!flip) return;
			i--;
		}
	}
	
	private function removeAllObjects():Void //removes all child objects from screen
	{
		this.removeChild(_map_ground);
		this.removeChild(_map_collide);
		
		for (aObject in _allObjs)
		{
			removeChild(aObject);
		}
		
		this.removeChild(_map_top);
		
		_allObjs = new Array<AnimatedSprite>();
	}
	
	public function loadNextMap(_next:String, _nextFacing:Int, _nextStart:Point):Void //Loads the next map
	{
		_tempPosTrans = 0;
		
		AreaMapHandler.init(_next);
		BattleHandler.init(_next);
		
		_map_ground = new AreaMap(_next, "ground");
		this.addChildAt(_map_ground, 0);
		
		_map_collide = new AreaMap(_next, "collide");
		this.addChildAt(_map_collide, 1);
		
		loadObjects(_next, Std.int(_nextStart.x), Std.int(_nextStart.y));
		_player.setFacing(_nextFacing);
		
		_map_top = new AreaMap(_next, "top");
		this.addChildAt(_map_top, numChildren);
		
		_map_dim = MapData.getMapDimension(_next);
	}
	
	public function toNextMap(next:String, playerFacing:Int, playerStart:Point):Void
	{
		_transitionBmp = new Bitmap(screenToBitmapData());
		_mapTransition = true;
		_active = false;
		removeAllObjects();
		loadNextMap(next, playerFacing, playerStart);
		GameUtil.scroll(_player, _cam, 0, _map_dim.wid, 0, _map_dim.hei, true, true);
		_transitionBmp.x = _cam.x;
		_transitionBmp.y = _cam.y;
		this.addChildAt(_transitionBmp, numChildren);
	}
	
	public function toTextMode(aObject:AreaNPC):Void //Sends screen into textmode and opens dialog box
	{
		_text = new AreaTextBox(_cam.x+((GameUtil.scrnWidth-800)/(2*GameUtil.ZOOM)), _cam.y, aObject.named, aObject.say);
		this.addChild(_text);
		_textMode = true;
	}
	
	public function toMenuMode():Void //Sends screen into menumode and opens menu
	{
		_menu = new AreaMenu(_cam.x, _cam.y);
		this.addChild(_menu);
		_menuMode = true;
	}
	
	private function toBattleMode():Void //Sends screen into battle transition
	{
		_battleTransition = false;
		_battleMode = true;
		_active = true;
		
		_enemiesToBattle = new Array<AreaEnemy>();
		for (ene in _enemies)
		{
			if (ene.area == _curBattleArea)
			{
				_enemiesToBattle.push(ene);
			}
		}
		
		BattleHandler.addAndConstructBattleObjects(_player, _cam, this, _enemiesToBattle);
		
		this.removeChild(_player);
		for (enemy in _enemies)
		{
			this.removeChild(enemy);
		}
	}
	
	public function toItemReceive(aItem:AreaItem):Void
	{
		_itemReceiveMode = true;
		var rItem:Item = aItem.getItem();
		var set:Bool = false;
		
		if (GameData.smallInventory.length >= 8)
		{
			if (rItem.getID() >= 3001)
			{
				var i:Int = 0;
				for (item in GameData.smallInventory)
				{
					if (item.getID() == rItem.getID())
					{
						if (item.getAmount() >= 99)
						{
							_quick = new AreaNotice("No room in your inventory for more " + item.getName() + "(s)!");
							set = true;
							break;
						}
						else
						{
							var amt:Int = rItem.getAmount();
							if (rItem.getAmount() + item.getAmount() > 99)
							{
								amt = 99 - item.getAmount();
							}
							_quick = new AreaNotice("Received " + amt + " " + item.getName() + "(s)!");
							GameData.smallInventory[i].add(amt);
							set = true;
							break;
						}
					}
					i++;
				}
				
				if (!set)
				{
					_quick = new AreaNotice("Cannot hold any more new consumables!");
					set = true;
				}
			}
			else
			{
				_quick = new AreaNotice("Cannot hold any more new equipment!");
				set = true;
			}
		}
		else
		{
			if (rItem.getID() >= 3001)
			{
				var i:Int = 0;
				for (item in GameData.smallInventory)
				{
					if (item.getID() == rItem.getID())
					{
						if (item.getAmount() >= 99)
						{
							GameData.smallInventory.push(ItemData.createConsumable(rItem.getID(), rItem.getAmount()));
							_quick = new AreaNotice("Received " + rItem.getAmount() + " " + item.getName() + "(s)!");
							set = true;
							break;
						}
						else
						{
							var amt:Int = rItem.getAmount();
							var overflow:Bool = false;
							
							if (rItem.getAmount() + item.getAmount() > 99)
							{
								amt = 99 - item.getAmount();
								GameData.smallInventory.push(ItemData.createConsumable(rItem.getID(), rItem.getAmount() - amt));
							}
							GameData.smallInventory[i].add(amt);
							_quick = new AreaNotice("Received " + amt + " " + item.getName() + "(s)!");
							set = true;
							break;
						}
					}
					i++;
				}
				
				if (!set)
				{
					GameData.smallInventory.push(ItemData.createConsumable(rItem.getID(), rItem.getAmount()));
					_quick = new AreaNotice("Received " + rItem.getAmount() + " " + ItemData.getNameFromID(rItem.getID()) + "(s)!");
					set = true;
				}
			}
			else
			{
				GameData.smallInventory.push(ItemData.createEquipment(rItem.getID()));
				_quick = new AreaNotice("Received a(n) " + ItemData.getNameFromID(rItem.getID()) + "!");
				set = true;
			}
		}
		
		_quick.x = _cam.x + _cam.width / 2 - _quick.width / 2;
		_quick.y = _cam.y + _cam.height / 2 - _quick.height / 2;
		this.addChild(_quick);
		this.removeChild(aItem);
		this._areaItems.remove(aItem);
		this._allObjs.remove(aItem);
	}
	
	public function toBattleTransition(area:Int):Void //Sends screen into battle transition
	{
		_active = false;
		_curBattleArea = area;
		_curBattleRect = BattleHandler.getBattleRect(area);
		
		if (_curBattleRect != null)
		{
			_closestRectSide = GameUtil.getClosestRectSide(_player.x, _player.y, _curBattleRect);
			_battleCamPosX = Std.int(_curBattleRect.x + _curBattleRect.width / 2 - _cam.width / 2);
			_battleCamPosY = Std.int(_curBattleRect.y + _curBattleRect.height / 2 - _cam.height / 2);
			_battleTransition = true;
		}
		else
		{
			trace("Battle Rectangle with area id \"" + area + "\" not found.");
		}
	}
	
	public function exitBattle(pla:Array<BattlePlayer>, ene:Array<BattleEnemy>):Void
	{
		_player.x = pla[0].x;
		_player.y = pla[0].y - GameData.party[0].getBattleTileYOffset();
		_player.setFacing(pla[0].getFacing());
		this.addChildAt(_player, this.getChildIndex(pla[0]));
		
		var i:Int = 0;
		for (enemy in ene)
		{
			if (!enemy.dead)
			{
				_enemiesToBattle[i].x = enemy.x;
				_enemiesToBattle[i].y = enemy.y;
				_enemiesToBattle[i].facing = enemy.getFacing();
				this.addChildAt(_enemiesToBattle[i], this.getChildIndex(enemy));
			}
			else
			{
				_enemies.remove(_enemiesToBattle[i]);
				_allObjs.remove(_enemiesToBattle[i]);
				_enemiesToBattle.remove(_enemiesToBattle[i]);
				//Original referenced in THREE locations. When deleting (NOT REMOVING FROM DISPLAY LIST) objects, all references must be removed.
			}
			i++;
		}
		
		_battleMode = false;
		BattleHandler.removeAndDestroyBattleObjects(this);
	}
	
	public function addAreaItem(item:AreaItem, index:Int):Void
	{
		_areaItems.push(item);
		_allObjs.push(item);
		this.addChildAt(item, index);
	}
	
	private function checkBattleReady(camReady:Bool, playerReady:Bool, enemyReady:Array<Bool>):Bool
	{
		if (!camReady)
		{
			return false;
		}
		
		if (!playerReady)
		{
			return false;
		}
		
		for (enemy in enemyReady)
		{
			if (!enemy)
			{
				return false;
			}
		}
		
		return true;
	}
	
	private function bitmapTransitionEffectIteration():Void
	{
		var tempPos:Int = 0;
		var tempCount:Int = 0;
		
		while (tempCount < 4)
		{
			for (ix in 0...Std.int(_transitionBmp.width))
			{
				_transitionBmp.bitmapData.setPixel32(ix, _tempPosTrans + tempPos, 0x00000000);
				_transitionBmp.bitmapData.setPixel32(ix, _tempPosTrans + tempPos + 1, 0x00000000);
				_transitionBmp.bitmapData.setPixel32(ix, Std.int(_transitionBmp.height - _tempPosTrans - tempPos), 0x00000000);
				_transitionBmp.bitmapData.setPixel32(ix, Std.int(_transitionBmp.height - _tempPosTrans - tempPos - 1), 0x00000000);
			}
			tempPos += Std.int(_transitionBmp.height / 4);
			tempCount++;
		}
		
		tempPos = 0;
		tempCount = 0;
		
		_tempPosTrans += 1;
	}
	
	private function screenToBitmapData():BitmapData //Copies pixels of all objects on screen into a single bitmapData object
	{
		var bmpData:BitmapData = new BitmapData(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, true, 0x000000);
		var bmpFinal:BitmapData = new BitmapData(Std.int(_cam.width), Std.int(_cam.height), true, 0x000000);
		
		bmpData.copyPixels(_map_ground.bitmapData, new Rectangle(0, 0, _map_ground.width, _map_ground.height), new Point(0, 0), null, null, true);
		bmpData.copyPixels(_map_collide.bitmapData, new Rectangle(0, 0, _map_collide.width, _map_collide.height), new Point(0, 0), null, null, true);
		
		_allObjs.sort(compareY);
		
		for (aObject in _allObjs)
		{
			if (aObject.scaleX == -1)
			{
				var flipMatrix:Matrix = new Matrix();
				flipMatrix.scale(-1, 1);
				flipMatrix.translate(aObject.width, 0);
				var storeBmp:Bitmap = new Bitmap(new BitmapData(Std.int(aObject.width), Std.int(aObject.height), true, 0x000000));
				storeBmp.bitmapData.draw(aObject.getBitmap().bitmapData, flipMatrix);
				bmpData.copyPixels(storeBmp.bitmapData, new Rectangle(0, 0, aObject.width, aObject.height), new Point(aObject.x - aObject.width / 2, aObject.y - aObject.height), null, null, true);
				storeBmp.bitmapData.dispose();
			}
			else
			{
				bmpData.copyPixels(aObject.getBitmap().bitmapData, new Rectangle(0, 0, aObject.width, aObject.height), new Point(aObject.x - aObject.width/2, aObject.y - aObject.height), null, null, true);
			}
		}
		
		bmpData.copyPixels(_map_top.bitmapData, new Rectangle(0, 0, _map_top.width, _map_top.height), new Point(0, 0), null, null, true);
		bmpFinal.copyPixels(bmpData, new Rectangle(_cam.x, _cam.y, _cam.width, _cam.height), new Point(0, 0), null, null, false);
		bmpData.dispose();
		bmpFinal.setPixel(0, 0, 0x000000);
		
		return bmpFinal;
	}
}