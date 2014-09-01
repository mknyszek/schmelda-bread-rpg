package main.mickny.schmelda.data;

import main.mickny.schmelda.game.battle.data.Character;
import main.mickny.schmelda.item.InventoryItem;
import haxe.Int32;
//import cpp.io.File;
//import cpp.io.FileOutput;
//import cpp.FileSystem;
//import cpp.Lib;
import main.mickny.schmelda.util.Dimension;
import openfl.Assets;
import openfl.display.Bitmap;

class GameData
{
	public static inline var MAX_PARTY_SIZE:Int = 3;
	public static inline var MAX_SMALL_INV_SIZE:Int = 8;
	
	public static var bigInventory:Array<InventoryItem>;
	public static var smallInventory:Array<InventoryItem>;
	public static var party:Array<Character>;
	public static var outOfParty:Array<Character>;
	
	public static function init():Void
	{
		smallInventory = createInventoryFromData([[3001, 5], [3002, 10], [3003, 85], [1001, 1]]);
		
		party = new Array<Character>();
		
		party.push(new Character("Crono", 88, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 1001, 0, 0, 0, 
			new Bitmap(Assets.getBitmapData("assets/img/player/player_battle_test.png")), new Dimension(43, 55), 8));
	}
	
	/*public static function load(file:Int):Void
	{
		var fname:String = "sav/save_data_" + Std.string(file) + ".dat";
		
		if (FileSystem.exists(fname))
		{
			
		}
	}*/
	
	/*
	 * Save File Format
	 * 
	 * 1. Party Size
	 * 2. Party Character Data
	 * 3. OutOfParty Size
	 * 4. OutOfParty Data
	 * 5. SmallInventory ID & COUNT
	 * 6. BigInventory ID & COUNT
	 * 7. Game Position (ID of Save Point)
	 * 8. Other Gameplay variables...
	 */
	
	/*public static function save(file:Int):Void
	{
		if (!FileSystem.exists("sav"))
		{
			FileSystem.createDirectory("sav");
		}
		
		var fname:String = "sav/save_data_" + Std.string(file) + ".dat";
		var fout:FileOutput = File.write(fname, true);
		
		fout.writeInt32(Int32.ofInt(party.length));
		
		for (char in party)
		{
			for (stat in char.toSaveData())
			{
				fout.writeInt32(stat);
			}
		}
		
		for (item in smallInventory)
		{
			fout.writeInt32(Int32.ofInt(item.getID()));
			fout.writeInt32(Int32.ofInt(item.getAmount()));
		}
		
		for (item in bigInventory)
		{
			fout.writeInt32(Int32.ofInt(item.getID()));
			fout.writeInt32(Int32.ofInt(item.getAmount()));
		}
		
		fout.close();
		return;
	}*/
	
	/*public static function delete(file:Int):Void
	{
		FileSystem.deleteFile("sav/save_data_" + Std.string(file) + ".dat");
		return;
	}*/
	
	private static function createInventoryFromData(data:Array<Array<Int>>):Array<InventoryItem>
	{
		var out:Array<InventoryItem> = new Array<InventoryItem>();
		
		for (item in data)
		{
			out.push(ItemData.createItem(item[0], item[1]));
		}
		
		return out;
	}
}