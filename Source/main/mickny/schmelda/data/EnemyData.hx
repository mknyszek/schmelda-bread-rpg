package main.mickny.schmelda.data;
import haxe.xml.Fast;
import main.mickny.schmelda.game.area.AreaEnemy;
import main.mickny.schmelda.game.battle.BattleEnemy;
import main.mickny.schmelda.game.battle.data.Ability;
import main.mickny.schmelda.item.Item;
import main.mickny.schmelda.util.animation.Animation;
import main.mickny.schmelda.util.Dimension;
import main.mickny.schmelda.util.GameUtil;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class EnemyData 
{
	private static var enemyData:Xml;
	
	public static function init():Void
	{
		var rawData:String = Assets.getText("assets/data/enemymap.xml");
		enemyData = Xml.parse(rawData);
	}
	
	//Needs ability support, to be designed.
	public static function getBattleEnemy(id:String, facing:Int, x:Float, y:Float):BattleEnemy
	{
		var bEnemy:BattleEnemy;
		var img:Bitmap;
		var data:Fast = new Fast(enemyData.firstChild());
		
		for(enemy in data.nodes.ENEMY)
		{
			if (enemy.att.ID == id)
			{
				for (be in enemy.nodes.BATTLE)
				{
					var ai:Array<Array<String>> = new Array<Array<String>>();
					var drops:Array<Item> = new Array<Item>();
					var chances:Array<Int> = new Array<Int>();
					var wander:Bool;
					var ranged:Bool;
					var i:Int = 0;
					
					for (list in be.nodes.AI)
					{
						for (step in list.nodes.STEP)
						{
							ai[i] = step.innerData.split(" ");
							trace(ai[i]);
							i++;
						}
					}
					
					for (item in be.nodes.DROP)
					{
						var bounds:Array<String> = item.att.AMT.split("-");
						var lowerInt:Int = Std.parseInt(bounds[0]);
						var upperInt:Int = Std.parseInt(bounds[1]);
						var count:Int = Math.floor(Math.random() * (upperInt - lowerInt) + lowerInt);
						
						drops.push(new Item(Std.parseInt(item.att.ID), count));
						chances.push(Std.parseInt(item.att.CHANCE));
					}
					
					if (be.att.IDLE_WANDER == "1") wander = true;
					else wander = false;
					
					if (be.att.RANGED == "1") ranged = true;
					else ranged = false;
					
					img = new Bitmap(Assets.getBitmapData("assets/img/enemy/" + be.att.IMG));
					bEnemy = new BattleEnemy(x, y, img, Std.parseInt(be.att.TILEWIDTH), Std.parseInt(be.att.TILEHEIGHT), Std.parseInt(be.att.HP), Std.parseInt(be.att.XP), be.att.STATS.split(" "),
						facing, new Array<Ability>(), ai, wander, ranged, drops, chances);
					
					for (anims in be.nodes.ANIMATIONS)
					{
						var idleDelay:Int = Std.parseInt(anims.node.IDLE.att.DELAY);
						bEnemy.idle = new Array<Animation>();
						bEnemy.idle[0] = new Animation("idleDown", img, GameUtil.stringToArray(anims.node.IDLE.att.D), idleDelay, false);
						bEnemy.idle[1] = new Animation("idleLeft", img, GameUtil.stringToArray(anims.node.IDLE.att.L), idleDelay, false);
						bEnemy.idle[2] = new Animation("idleUp", img, GameUtil.stringToArray(anims.node.IDLE.att.U), idleDelay, false);
						
						var moveDelay:Int = Std.parseInt(anims.node.MOVE.att.DELAY);
						bEnemy.move = new Array<Animation>();
						bEnemy.move[0] = new Animation("moveDown", img, GameUtil.stringToArray(anims.node.MOVE.att.D), moveDelay);
						bEnemy.move[1] = new Animation("moveLeft", img, GameUtil.stringToArray(anims.node.MOVE.att.L), moveDelay);
						bEnemy.move[2] = new Animation("moveUp", img, GameUtil.stringToArray(anims.node.MOVE.att.U), moveDelay);
						
						var attackDelay:Int = Std.parseInt(anims.node.ATTACK.att.DELAY);
						bEnemy.attack = new Array<Animation>();
						bEnemy.attack[0] = new Animation("attackDown", img, GameUtil.stringToArray(anims.node.ATTACK.att.D), attackDelay, false);
						bEnemy.attack[1] = new Animation("attackLeft", img, GameUtil.stringToArray(anims.node.ATTACK.att.L), attackDelay, false);
						bEnemy.attack[2] = new Animation("attackUp", img, GameUtil.stringToArray(anims.node.ATTACK.att.U), attackDelay, false);
					}
					
					return bEnemy;
				}
			}
		}
		
		return null;
	}
	
	public static function getAreaEnemyImage(id:String):Bitmap
	{
		var data:Fast = new Fast(enemyData.firstChild());
		for(enemy in data.nodes.ENEMY)
		{
			if (enemy.att.ID == id)
			{
				for (ae in enemy.nodes.AREA)
				{
					return new Bitmap(Assets.getBitmapData("assets/img/enemy/" + ae.att.IMG));
				}
			}
		}
		trace("Cannot find enemy of ID: " + id);
		return new Bitmap(new BitmapData(10, 10));
	}
	
	public static function getAreaEnemySize(id:String):Dimension
	{
		var data:Fast = new Fast(enemyData.firstChild());
		for(enemy in data.nodes.ENEMY)
		{
			if (enemy.att.ID == id)
			{
				for (ae in enemy.nodes.AREA)
				{
					return new Dimension(Std.parseInt(ae.att.TILEWIDTH), Std.parseInt(ae.att.TILEHEIGHT));
				}
			}
		}
		trace("Cannot find enemy of ID: " + id);
		return new Dimension(1, 1);
	}
	
	public static function setupAreaEnemyAnimations(e:AreaEnemy, bmp:Bitmap):Void
	{
		var data:Fast = new Fast(enemyData.firstChild());
		for(enemy in data.nodes.ENEMY)
		{
			if (enemy.att.ID == e.getID())
			{
				for (ae in enemy.nodes.AREA)
				{
					var delay:Int = Std.parseInt(ae.att.DELAY);
					e.walk = new Animation("walk", bmp, GameUtil.stringToArray(ae.att.WALK), delay);
					e.idle = new Animation("idle", bmp, GameUtil.stringToArray(ae.att.IDLE), delay);
					e.attack = new Animation("attack", bmp, GameUtil.stringToArray(ae.att.ATTACK), delay);
				}
			}
		}
	}
}