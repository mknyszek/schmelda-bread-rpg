package main.mickny.schmelda.data;

import main.mickny.schmelda.game.battle.BattleRectangle;
import main.mickny.schmelda.util.Dimension;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import haxe.xml.Fast;

class MapData
{
	private static var mapData:Xml;
	public static var emptyScreen:BitmapData;
		
	public static function init():Void
	{
		var rawData:String = Assets.getText("assets/data/mapdata.xml");
		mapData = Xml.parse(rawData);
		
		emptyScreen = new BitmapData(640, 360, false, 0x000000);
	}
		
	public static function getMap(id:String, type:String):Array<Array<Int>>
	{
		var temp:Array<String> = new Array<String>();
		var temp2:Array<Array<String>> = new Array<Array<String>>();
		var map:Array<Array<Int>>;
		var raw:String;
		
		raw = getMapData(id, type);
		temp = raw.split("\n");
		map = new Array<Array<Int>>();
		
		var lT:Int = temp.length;
		var lM:Int;
		var i:Int = 0;
		var j:Int = 0;
		
		if (raw != null)
		{
			while(i < lT)
			{
				temp2[i] = temp[i].split(", ");
				lM = temp2[i].length;
				map[i] = new Array<Int>();
				
				j = 0;
				
				while(j < lM)
				{
					map[i][j] = Std.parseInt(temp2[i][j]);
					j++;
				}
				
				i++;
			}
		}
		
		return map;
	}
	
	public static function getTileSheet(id:String):Bitmap
	{
		var bmp:Bitmap;
		var data:Fast = new Fast(mapData.firstChild());
		var loc:String = "";
		
		for(map in data.nodes.MAP)
		{
			if (map.att.ID == id)
			{
				loc = map.att.TILEMAP;
			}
		}
		
		bmp = new Bitmap(Assets.getBitmapData("assets/img/tiles/" + loc));
		
		return bmp;
	}
	
	public static function getMapDimension(id:String):Dimension
	{
		var out:Dimension = null;
		var data:Fast = new Fast(mapData.firstChild());
		
		for(map in data.nodes.MAP)
		{
			if (map.att.ID == id)
			{
				out = new Dimension(Std.parseInt(map.att.WIDTH)*16, Std.parseInt(map.att.HEIGHT)*16);
			}
		}
		
		return out;
	}
	
	public static function getGotoRects(id:String):Array<Rectangle>
	{
		var out:Array<Rectangle> = new Array<Rectangle>();
		var data:Fast = new Fast(mapData.firstChild());
		var x:Int;
		var y:Int;
		var w:Int;
		var h:Int;
		
		for(map in data.nodes.MAP)
		{
			if (map.att.ID == id)
			{
				for (goto in map.nodes.GOTO)
				{
					for (rect in goto.nodes.RECT)
					{
						x = Std.parseInt(rect.att.X);
						y = Std.parseInt(rect.att.Y);
						w = Std.parseInt(rect.att.WIDTH);
						h = Std.parseInt(rect.att.HEIGHT);
						out.push(new Rectangle(x << 4, y << 4, w << 4, h << 4));
					}
				}
			}
		}
		
		return out;
	}
	
	public static function getBattleRects(id:String):Array<BattleRectangle>
	{
		var out:Array<BattleRectangle> = new Array<BattleRectangle>();
		var data:Fast = new Fast(mapData.firstChild());
		var x:Int;
		var y:Int;
		var w:Int;
		var h:Int;
		var a:Int;
		var i:Int;
		var ab:Bool;
		
		for(map in data.nodes.MAP)
		{
			if (map.att.ID == id)
			{
				for (batreg in map.nodes.BATTLE_REGION)
				{
					a = Std.parseInt(batreg.att.ACTIVE);
					
					if (a == 1)
					{
						ab = true;
					}
					else
					{
						ab = false;
					}
					
					i = Std.parseInt(batreg.att.AREA);
					x = Std.parseInt(batreg.att.X);
					y = Std.parseInt(batreg.att.Y);
					w = Std.parseInt(batreg.att.WIDTH);
					h = Std.parseInt(batreg.att.HEIGHT);
					out.push(new BattleRectangle(ab, i, x << 4, y << 4, w << 4, h << 4));
				}
			}
		}
		
		return out;
	}
	
	public static function getGotoMaps(id:String):Array<String>
	{
		var out:Array<String> = new Array<String>();
		var data:Fast = new Fast(mapData.firstChild());
		
		for(map in data.nodes.MAP)
		{
			if (map.att.ID == id)
			{
				for (goto in map.nodes.GOTO)
				{
					out.push(goto.att.MAP);
				}
			}
		}
		
		return out;
	}
	
	public static function getGotoPoints(id:String):Array<Point>
	{
		var out:Array<Point> = new Array<Point>();
		var data:Fast = new Fast(mapData.firstChild());
		var x:Int;
		var y:Int;
		
		for(map in data.nodes.MAP)
		{
			if (map.att.ID == id)
			{
				for (goto in map.nodes.GOTO)
				{
					x = Std.parseInt(goto.att.BXSTART);
					y = Std.parseInt(goto.att.BYSTART);
					out.push(new Point(x << 4, y << 4));
				}
			}
		}
		
		return out;
	}
	
	public static function getGotoFacing(id:String):Array<Int>
	{
		var out:Array<Int> = new Array<Int>();
		var data:Fast = new Fast(mapData.firstChild());
		
		for(map in data.nodes.MAP)
		{
			if (map.att.ID == id)
			{
				for (goto in map.nodes.GOTO)
				{
					out.push(Std.parseInt(goto.att.FACING));
				}
			}
		}
		
		return out;
	}
	
	private static function getMapData(id:String, type:String):String
	{
		var data:Fast = new Fast(mapData.firstChild());
		
		for(map in data.nodes.MAP)
		{
			if (map.att.ID == id)
			{
				if (type == "collide")
				{
					return Assets.getText("assets/data/maps/" + id + "_collide.txt");
				}
				else if (type == "top")
				{
					return Assets.getText("assets/data/maps/" + id + "_top.txt");
				}
				else
				{
					return Assets.getText("assets/data/maps/" + id + "_ground.txt");
				}
			}
		}
		
		return null;
	}
}