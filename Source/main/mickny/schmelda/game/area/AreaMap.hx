package main.mickny.schmelda.game.area;

import main.mickny.schmelda.data.MapData;
import main.mickny.schmelda.util.GameUtil;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class AreaMap extends Bitmap
{
	private static inline var TILE_SIZE:Int = Std.int(32 / GameUtil.ZOOM);
	private var map:Array<Array<Int>>;
	private var entry:Point;
	private var lHeight:Int;
	private var lBase:Int;
	private var tileSheet:Bitmap;
	
	public function new(mapID:String, type:String)
	{
		map = MapData.getMap(mapID, type);
		tileSheet = MapData.getTileSheet(mapID);
		
		lHeight = map.length;
		lBase = map[0].length;
		
		super(new BitmapData(TILE_SIZE * lBase, TILE_SIZE * lHeight, true, 0x000000));
		
		create(map);
	}
	
	public function getTileValue(blockX:Int, blockY:Int):Int
	{
		return map[blockY][blockX];
	}
	
	public function getMapWidth():Int
	{
		return lBase;
	}
	
	public function getMapHeight():Int
	{
		return lHeight;
	}
	
	public function getEntryPoint():Point
	{
		return entry;
	}
	
	private function create(level:Array<Array<Int>>):Void
	{
		var i:Int = 0;
		var j:Int = 0;
		while(i < lHeight)
		{
			j = 0;
			while(j < lBase)
			{
				if(level[i][j] != 0)
				{
					addTile(level[i][j], j, i);
				}
				j++;
			}
			i++;
		}
	}
		
	private function getImage(tileNum:Int):Bitmap
	{
		var lineWidth:Int = Std.int(tileSheet.bitmapData.width / TILE_SIZE);
		var rect:Rectangle;
		var pt:Point = new Point(0, 0);
		
		rect = new Rectangle((tileNum % lineWidth) * TILE_SIZE, Math.floor(tileNum / lineWidth) * TILE_SIZE, TILE_SIZE, TILE_SIZE);
		
		var bmp:Bitmap = new Bitmap(new BitmapData(TILE_SIZE, TILE_SIZE, true, 0));
		bmp.bitmapData.copyPixels(tileSheet.bitmapData, rect, pt, null, null, true);
		
		return bmp;
	}
		
	private function addTile(tileNum:Int, block_x:Int, block_y:Int):Void 
	{
		var bmp:Bitmap = getImage(tileNum-1);
		
		var rect:Rectangle = new Rectangle(0, 0, TILE_SIZE, TILE_SIZE);
		
		var pt:Point = new Point(block_x * TILE_SIZE, block_y * TILE_SIZE);
		
		this.bitmapData.copyPixels(bmp.bitmapData, rect, pt, null, null, true);
	}
}