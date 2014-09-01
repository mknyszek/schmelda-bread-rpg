package main.mickny.schmelda.game.area;

import main.mickny.schmelda.data.MapData;
import main.mickny.schmelda.game.area.AreaPlayer;
import main.mickny.schmelda.game.screen.AreaScreen;

import openfl.geom.Rectangle;
import openfl.geom.Point;

class AreaMapHandler 
{
	private static var gotoRectArray:Array<Rectangle>;
	private static var gotoMapNameArray:Array<String>;
	private static var gotoPointStartArray:Array<Point>;
	private static var gotoFacingStartArray:Array<Int>;
	
	public static function init(id:String):Void
	{
		gotoRectArray = MapData.getGotoRects(id);
		gotoMapNameArray = MapData.getGotoMaps(id);
		gotoPointStartArray = MapData.getGotoPoints(id);
		gotoFacingStartArray = MapData.getGotoFacing(id);
	}
	
	public static function check(player:AreaPlayer, screen:AreaScreen):Bool
	{
		var count:Int = 0;
		for (rect in gotoRectArray)
		{
			if (player.getHitRect().intersects(rect))
			{
				screen.toNextMap(gotoMapNameArray[count], gotoFacingStartArray[count], gotoPointStartArray[count]);
				return true;
			}
			count++;
		}
		
		return false;
	}
}