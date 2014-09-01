package main.mickny.schmelda.game.battle.data;

import haxe.Int32;
import main.mickny.schmelda.data.CharacterData;
import main.mickny.schmelda.data.ItemData;
import main.mickny.schmelda.item.Consumable;
import main.mickny.schmelda.item.Equipment;
import main.mickny.schmelda.util.animation.Animation;
import main.mickny.schmelda.util.Dimension;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.text.TextField;

class Character
{
	//How much XP for each stat it takes to raise it by 1.
	public static inline var MAX_STAMINA:Int = 10000;
	
	private static function getXPNeeded(statLvl:Int):Int
	{
		return Math.ceil(Math.sqrt(statLvl * statLvl * statLvl));
	}
	
	//ALL STATS MUST ALWAYS BE >1
	
	//Which character is this?
	private var who:String;
	
	//Primitive Statistics
	private var base_hp:Int;
	private var str:Int; //Strength
	private var vit:Int; //Vitality
	private var res:Int; //Resiliance
	private var int:Int; //Intelligence
	private var agi:Int; //Agility
	private var dex:Int; //Dexterity
	
	//Primitive Statistics XP - Always a number between 0 and XP_PER_STAT_LEVEL-1
	private var str_xp:Int; //Strength
	private var vit_xp:Int; //Vitality
	private var res_xp:Int; //Resiliance
	private var int_xp:Int; //Intelligence
	private var agi_xp:Int; //Agility
	private var dex_xp:Int; //Dexterity
	
	//Factor of XP multiplication for stats
	private var str_m:Float;
	private var vit_m:Float;
	private var res_m:Float;
	private var int_m:Float;
	private var agi_m:Float;
	private var dex_m:Float;
	
	//Final Battle Statistics
	private var atk:Int; //str, vit, weapon, accessory
	private var def:Int; //vit, res, weapon, accessory
	private var tec:Int; //int, str, dex, weapon, accessory
	private var spd:Int; //agi, armor, weapon, accessory
	private var acc:Int; //dex, int, weapon, accessory
	private var max_hp:Int; //result of vit, res, weapon, accessory
	private var cur_hp:Int; //>= 0, <= max_hp
	private var cur_stamina:Int; //Placeholder so info can be retrieved for display in battle, otherwise pointless
	
	//Equipment
	private var weapon:Equipment;
	private var accessory:Equipment;
	private var carry:Consumable;
	
	//Sprite Data
	private var area_image:Bitmap;
	private var area_tile:Dimension;
	private var area_idle:Array<Int>;
	private var area_move:Array<Animation>;
	
	private var battle_image:Bitmap;
	private var battle_tile:Dimension;
	private var battle_y_offset:Int; //Y offset amount in pixels from area image's baseline.
	
	//private var world_image:Bitmap;
	
	public function new(who:String, cur_hp:Int, str:Int, vit:Int, res:Int, int:Int, agi:Int, dex:Int, 
		str_xp:Int, vit_xp:Int, res_xp:Int, int_xp:Int, agi_xp:Int, dex_xp:Int, weapon:Int, accessory:Int, carry:Int, 
		carry_amt:Int, battle_image:Bitmap, battle_tile:Dimension, battle_y_offset:Int)
	{
		this.who = who;
		
		this.base_hp = CharacterData.getBaseHP(who);
		this.str = str;
		this.vit = vit;
		this.res = res;
		this.int = int;
		this.agi = agi;
		this.dex = dex;
		
		this.str_xp = str_xp;
		this.vit_xp = vit_xp;
		this.res_xp = res_xp;
		this.int_xp = int_xp;
		this.agi_xp = agi_xp;
		this.dex_xp = dex_xp;
		
		var stat_multi:Array<Float> = CharacterData.getInnateStatMultipliers(who);
		this.str_m = stat_multi[0];
		this.vit_m = stat_multi[1];
		this.res_m = stat_multi[2];
		this.int_m = stat_multi[3];
		this.agi_m = stat_multi[4];
		this.dex_m = stat_multi[5];
		
		this.weapon = ItemData.createEquipment(weapon);
		this.accessory = ItemData.createEquipment(accessory);
		this.carry = ItemData.createConsumable(carry, carry_amt);
		
		this.area_image = CharacterData.getAreaImage(who);
		this.area_tile = CharacterData.getAreaImageDimensions(who);
		this.area_idle = CharacterData.getAreaIdleFrames(who);
		this.area_move = CharacterData.getAreaMoveAnimations(who, area_image);
		
		this.battle_image = battle_image;
		this.battle_tile = battle_tile;
		this.battle_y_offset = battle_y_offset;
		
		updateBattleStats();
		
		if (cur_hp > max_hp)
		{
			this.cur_hp = max_hp;
		}
		else if (cur_hp < 0)
		{
			this.cur_hp = 0;
		}
		else 
		{
			this.cur_hp = cur_hp;
		}
		
		cur_stamina = MAX_STAMINA;
	}
	
	public function getName():String
	{
		return who;
	}
	
	public function getCurrentHP():Int
	{
		return cur_hp;
	}
	
	public function getMaxHP():Int
	{
		return max_hp;
	}
	
	public function getAreaImage():Bitmap
	{
		return area_image;
	}
	
	public function getAreaTileSize():Dimension
	{
		return area_tile;
	}
	
	public function getAreaIdleFrames():Array<Int>
	{
		return area_idle;
	}
	
	public function getAreaMoveAnimations():Array<Animation>
	{
		return area_move;
	}
	
	public function getBattleImage():Bitmap
	{
		return battle_image;
	}
	
	public function getBattleTileSize():Dimension
	{
		return battle_tile;
	}
	
	public function getBattleTileYOffset():Int
	{
		return battle_y_offset;
	}
	
	public function addHP(change:Int):Void
	{
		cur_hp += change;
		if (cur_hp > max_hp)
		{
			cur_hp = max_hp;
		}
		else if (cur_hp < 0)
		{
			cur_hp = 0;
		}
	}
	
	public function getCurrentStamina():Int
	{
		return cur_stamina;
	}
	
	public function updateCurrentStamina(sta:Int):Void
	{
		cur_stamina = sta;
	}
	
	public function getStaminaRegenFrame():Int
	{
		return Math.floor(Math.log(spd) * 6);
	}
	
	public function getRawDamageOutput():Int
	{
		return atk * atk;
	}
	
	public function computeFinalDamage(rawDamage:Int, ?ranged:Bool = false):Int
	{
		return Math.ceil(rawDamage - def * Math.pow(rawDamage, (1.0/3.0)));
	}
	
	public function gainXP(amt:Int):Void
	{
		str_xp += Std.int(amt * str_m);
		vit_xp += Std.int(amt * vit_m);
		res_xp += Std.int(amt * res_m);
		int_xp += Std.int(amt * int_m);
		agi_xp += Std.int(amt * agi_m);
		dex_xp += Std.int(amt * dex_m);
		
		if (str_xp >= getXPNeeded(str))
		{
			str_xp = str_xp - getXPNeeded(str);
			str++;
		}
		
		if (vit_xp >= getXPNeeded(vit))
		{
			vit_xp = vit_xp - getXPNeeded(vit);
			vit++;
		}
		
		if (res_xp >= getXPNeeded(res))
		{
			res_xp = res_xp - getXPNeeded(res);
			res++;
		}
		
		if (int_xp >= getXPNeeded(int))
		{
			int_xp = int_xp - getXPNeeded(int);
			int++;
		}
		
		if (agi_xp >= getXPNeeded(agi))
		{
			agi_xp = agi_xp - getXPNeeded(agi);
			agi++;
		}
		
		if (dex_xp >= getXPNeeded(dex))
		{
			dex_xp = dex_xp - getXPNeeded(dex);
			dex++;
		}
		
		updateBattleStats();
	}
	
	public function setTextFieldsForPrim(arr:Array<TextField>):Void
	{
		arr[0].text = Std.string(str);
		arr[1].text = Std.string(vit);
		arr[2].text = Std.string(res);
		arr[3].text = Std.string(int);
		arr[4].text = Std.string(agi);
		arr[5].text = Std.string(dex);
	}
	
	public function setTextFieldsForBattle(arr:Array<TextField>):Void
	{
		arr[0].text = Std.string(atk);
		arr[1].text = Std.string(def);
		arr[2].text = Std.string(tec);
		arr[3].text = Std.string(spd);
	}
	
	public function setXPBarWidths(arr:Array<Sprite>):Void
	{
		arr[0].width = arr[0].width * str_xp / getXPNeeded(str);
		arr[1].width = arr[1].width * vit_xp / getXPNeeded(vit);
		arr[2].width = arr[2].width * res_xp / getXPNeeded(res);
		arr[3].width = arr[3].width * int_xp / getXPNeeded(int);
		arr[4].width = arr[4].width * agi_xp / getXPNeeded(agi);
		arr[5].width = arr[5].width * dex_xp / getXPNeeded(dex);
	}
	
	/*public function toSaveData():Array<Int32>
	{
		var arr:Array<Int32> = new Array<Int32>();
		
		arr[0] = haxe.Int32.ofInt(str);
		arr[1] = haxe.Int32.ofInt(vit);
		arr[2] = haxe.Int32.ofInt(res);
		arr[3] = haxe.Int32.ofInt(int);
		arr[5] = haxe.Int32.ofInt(agi);
		arr[6] = haxe.Int32.ofInt(dex);
		arr[7] = haxe.Int32.ofInt(weapon.getID());
		arr[8] = haxe.Int32.ofInt(accessory.getID());
		arr[9] = haxe.Int32.ofInt(carry.getID());
		
		return arr;
	}*/
	
	private function updateBattleStats():Void
	{
		atk = Math.ceil(Math.sqrt(str * str * vit));
		def = Math.ceil(Math.sqrt(Math.pow(vit, 1.5) * Math.pow(res, 1.5)));
		tec = Math.ceil(Math.sqrt(Math.sqrt(str) * Math.pow(int, 1.5) * dex));
		spd = Math.ceil(Math.sqrt(Math.pow(vit, 1.5) * Math.pow(agi, 1.5)));
		acc = 1;
		max_hp = Math.ceil(base_hp * (Math.sqrt(vit * res) + 1));
		trace(max_hp);
	}
	
	private function addEquipToBattleStats():Void
	{
		
	}
}