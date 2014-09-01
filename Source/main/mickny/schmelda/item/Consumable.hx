package main.mickny.schmelda.item;
import openfl.display.Bitmap;

class Consumable extends InventoryItem
{
	/*
	 * Consumable IDs: 3001 - 3999
	 * 
	 * Usage Codes:
		 * A - All
		 * B - Battle
		 * O - Outside of Battle
	 * 
	 * Effect Codes:
		 * (stat)(+ - * /)(amount)&(duration in time)
		 * Can be multiple, separated by space in itemmap.xml
		 * _(duration in 'time') is optional
	 */
	
	public static inline var MAX_COUNT:Int = 99;
	
	private var usage:String;
	private var effects:Array<String>;
	
	public function new(id:Int, count:Int, name:String, image:Bitmap, description:String, effects:Array<String>) 
	{
		super(id, count, name, image, description);
		this.effects = effects;
	}
}