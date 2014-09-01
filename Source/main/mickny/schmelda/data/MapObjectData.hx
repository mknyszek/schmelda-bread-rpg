package main.mickny.schmelda.data;

import main.mickny.schmelda.game.area.AreaEnemy;
import main.mickny.schmelda.game.area.AreaNPC;
import main.mickny.schmelda.game.area.AreaObject;
import main.mickny.schmelda.util.animation.Animation;
import main.mickny.schmelda.util.GameUtil;

import openfl.Assets;
import openfl.display.Bitmap;
import haxe.xml.Fast;

class MapObjectData
{
	private static var mapObjectData:Xml;
	
	public static function init():Void
	{
		var rawData:String = Assets.getText("assets/data/mapobjectdata.xml");
		mapObjectData = Xml.parse(rawData);
	}
		
	public static function getAreaNPCArray(id:String):Array<AreaNPC>
	{
		var data:Fast = new Fast(mapObjectData.firstChild());
		var out:Array<AreaNPC> = new Array<AreaNPC>();
		var active:Int;
		var animated:Bool;
		var bmp:Bitmap;
		
		for(map in data.nodes.MAP)
		{
			if (map.att.ID == id)
			{
				for (object in map.nodes.OBJECT)
				{
					active = Std.parseInt(object.att.ANIMATED);
					bmp = new Bitmap(Assets.getBitmapData("assets/img/npc/" + object.att.IMG));
					
					if (active == 1)
					{
						animated = true;
					}
					else
					{
						animated = false;
					}
					
					var x:AreaNPC = new AreaNPC(object.att.NAME, bmp, animated, Std.parseInt(object.att.X), Std.parseInt(object.att.Y), id, Std.parseInt(object.att.TILEWIDTH), Std.parseInt(object.att.TILEHEIGHT));
					x.fWalk = new Animation("fwalk", bmp, GameUtil.stringToArray(object.att.FWALK), 8);
					x.sWalk = new Animation("swalk", bmp, GameUtil.stringToArray(object.att.SWALK), 8);
					x.bWalk = new Animation("bwalk", bmp, GameUtil.stringToArray(object.att.BWALK), 8);
					x.still = new Animation("still", bmp, GameUtil.stringToArray(object.att.STILL), 200);
					out.push(x);
				}
			}
		}
		
		return out;
	}
	
	public static function getAreaEnemyArray(id:String):Array<AreaEnemy>
	{
		var data:Fast = new Fast(mapObjectData.firstChild());
		var out:Array<AreaEnemy> = new Array<AreaEnemy>();
		
		for(map in data.nodes.MAP)
		{
			if (map.att.ID == id)
			{
				for (enemy in map.nodes.ENEMY)
				{
					var aggro:Bool;
					var ag:Int;
					ag = Std.parseInt(enemy.att.AGGRO);
					
					if (ag == 1)
					{
						aggro = true;
					}
					else
					{
						aggro = false;
					}
					var eid:String = enemy.att.ID;
					var bmp:Bitmap = EnemyData.getAreaEnemyImage(eid);
					var x:AreaEnemy = new AreaEnemy(eid, Std.parseInt(enemy.att.AREA), Std.parseInt(enemy.att.X), 
						Std.parseInt(enemy.att.Y), enemy.innerData, aggro, bmp, EnemyData.getAreaEnemySize(eid));
					EnemyData.setupAreaEnemyAnimations(x, bmp);
					out.push(x);
				}
			}
		}
		
		return out;
	}
}