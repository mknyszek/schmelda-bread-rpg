package main.mickny.schmelda.item;

import openfl.display.Bitmap;

class InventoryItem extends Item
{
	/*
	 * Consumable IDs: 3001 - 3999
	 * Weapon IDs: 1001 - 1999
	 * Accessory IDs: 2001 - 2999
	 */
	
	private var name:String;
	private var description:String;
	private var image:Bitmap;
	
	private function new(id:Int, count:Int, name:String, image:Bitmap, description:String)
	{
		super(id, count);
		this.name = name;
		this.image = image;
		this.description = description;
	}
	
	public function getName():String
	{
		return name;
	}
	
	public function getIcon():Bitmap
	{
		return image;
	}
	
	public function getDescription():String
	{
		return description;
	}
	
	public function add(amt:Int):Void
	{
		this.count += amt;
	}
}