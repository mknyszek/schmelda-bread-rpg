package main.mickny.schmelda.data;

import haxe.xml.Fast;
import main.mickny.schmelda.item.Consumable;
import main.mickny.schmelda.item.Equipment;
import main.mickny.schmelda.item.InventoryItem;
import openfl.Assets;
import openfl.display.Bitmap;

class ItemData 
{
	private static var itemMap:Xml;
	
	public static function init():Void
	{
		var rawData:String = Assets.getText("assets/data/itemmap.xml").toString();
		itemMap = Xml.parse(rawData);
	}
	
	//Mainly a generic inventory retrieval function.
	public static function createItem(id:Int, count:Int):InventoryItem
	{
		var data:Fast = new Fast(itemMap.firstChild());
		
		if (id == 0)
		{
			return null;
		}
		else if (id < 3000)
		{
			for(item in data.nodes.EQUIPMENT)
			{
				if (Std.parseInt(item.att.ID) == id)
				{
					var grow:String = item.att.GROW;
					var bonus:String = item.att.BONUS;
					var bmp:Bitmap = new Bitmap(Assets.getBitmapData("assets/img/item/" + item.att.IMAGE));
					var equip:Equipment = new Equipment(id, item.att.NAME, bmp, item.innerData, item.att.USAGE, grow.split(" "), bonus.split(" "));
					return equip;
				}
			}
		}
		else
		{
			for(item in data.nodes.CONSUMABLE)
			{
				if (Std.parseInt(item.att.ID) == id)
				{
					var effect:String = item.att.EFFECT;
					var bmp:Bitmap = new Bitmap(Assets.getBitmapData("assets/img/item/" + item.att.IMAGE));
					var con:Consumable = new Consumable(id, count, item.att.NAME, bmp, item.innerData, effect.split(" "));
					return con;
				}
			}
		}
		
		trace("Item ID Not Found! ID: " + id);
		return null;
	}
	
	//Used for specific instances, such as loading equipment. NEEDED FOR CHARACTER CLASS.
	public static function createEquipment(id:Int):Equipment
	{
		var data:Fast = new Fast(itemMap.firstChild());
		
		if (id == 0)
		{
			return null;
		}
		else if (id < 3000)
		{
			for(item in data.nodes.EQUIPMENT)
			{
				if (Std.parseInt(item.att.ID) == id)
				{
					var grow:String = item.att.GROW;
					var bonus:String = item.att.BONUS;
					var bmp:Bitmap = new Bitmap(Assets.getBitmapData("assets/img/item/" + item.att.IMAGE));
					var equip:Equipment = new Equipment(id, item.att.NAME, bmp, item.innerData, item.att.USAGE, grow.split(" "), bonus.split(" "));
					return equip;
				}
			}
			trace("Item ID Not Found! ID: " + id);
			return null;
		}
		
		trace("Item ID Not In Correct Range! ID: " + id);
		return null;
	}
	
	//Used for specific instances, such as loading equipment.
	public static function createConsumable(id:Int, count:Int):Consumable
	{
		var data:Fast = new Fast(itemMap.firstChild());
		
		if (id == 0)
		{
			return null;
		}
		else if (id > 3000)
		{
			for(item in data.nodes.CONSUMABLE)
			{
				if (Std.parseInt(item.att.ID) == id)
				{
					var effect:String = item.att.EFFECT;
					var bmp:Bitmap = new Bitmap(Assets.getBitmapData("assets/img/item/" + item.att.IMAGE));
					var con:Consumable = new Consumable(id, count, item.att.NAME, bmp, item.innerData, effect.split(" "));
					return con;
				}
			}
			trace("Item ID Not Found! ID: " + id);
			return null;
		}
		
		trace("Item ID Not In Correct Range! ID: " + id);
		return null;
	}
	
	public static function getNameFromID(id:Int):String
	{
		var data:Fast = new Fast(itemMap.firstChild());
		
		for (item in data.nodes.CONSUMABLE)
		{
			if (Std.parseInt(item.att.ID) == id)
			{
				return item.att.NAME;
			}
		}
		
		for (item in data.nodes.EQUIPMENT)
		{
			if (Std.parseInt(item.att.ID) == id)
			{
				return item.att.NAME;
			}
		}
		
		trace("Item ID Not Found! ID: " + id);
		return "";
	}
}