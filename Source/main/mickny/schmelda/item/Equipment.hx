package main.mickny.schmelda.item;
import openfl.display.Bitmap;

class Equipment extends InventoryItem
{
	/*
	 * Weapon IDs: 1001 - 1999
	 * Accessory IDs: 2001 - 2999
	 * 
	 * Bonus Codes:
		 * (stat)(+ - * /)(amount)
		 * Can be multiple, separated by space in itemmap.xml
	 */
	
	public static inline var MAX_COUNT:Int = 1;
	
	private var bonus:Array<String>;
	private var grow:Array<String>;
	private var usage:String;
	
	public function new(id:Int, name:String, image:Bitmap, description:String, usage:String, grow:Array<String>, bonus:Array<String>) 
	{
		super(id, 1, name, image, description);
		this.usage = usage;
		this.grow = grow;
		this.bonus = bonus;
	}
	
	public override function add(amt:Int):Void
	{
		trace("Equipment cannot be stacked!");
	}
}