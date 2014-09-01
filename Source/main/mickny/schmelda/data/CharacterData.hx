package main.mickny.schmelda.data;
import haxe.xml.Fast;
import main.mickny.schmelda.util.animation.Animation;
import main.mickny.schmelda.util.Dimension;
import main.mickny.schmelda.util.GameUtil;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class CharacterData 
{
	private static var characterData:Xml;
	
	public static function init():Void
	{
		var rawData:String = Assets.getText("assets/data/charactermap.xml");
		characterData = Xml.parse(rawData);
	}
	
	public static function getBaseHP(name:String):Int
	{
		var data:Fast = new Fast(characterData.firstChild());
		
		for (char in data.nodes.CHAR)
		{
			if (char.att.NAME == name)
			{
				return Std.parseInt(char.node.BASE_HP.innerData);
			}
		}
		
		trace("Character " + name + " not found.");
		
		return 0;
	}
	
	public static function getInnateStatMultipliers(name:String):Array<Float>
	{
		var data:Fast = new Fast(characterData.firstChild());
		var arr:Array<Float> = new Array<Float>();
		
		for (char in data.nodes.CHAR)
		{
			if (char.att.NAME == name)
			{
				var arrStr:Array<String> = char.node.STAT_MULTI.innerData.split(" ");
				
				var i:Int = 0;
				for (str in arrStr)
				{
					arr[i] = Std.parseFloat(str);
					i++;
				}
				
				return arr;
			}
		}
		
		trace("Character " + name + " not found.");
		
		for (i in 0...6)
		{
			arr.push(1);
		}
		
		return arr;
	}
	
	public static function getAreaImage(name:String):Bitmap
	{
		var data:Fast = new Fast(characterData.firstChild());
		var bmp:Bitmap;
		
		for (char in data.nodes.CHAR)
		{
			if (char.att.NAME == name)
			{
				bmp = new Bitmap(Assets.getBitmapData("assets/img/player/" + char.node.ANIMATIONS.node.AREA.att.IMG));
				
				return bmp;
			}
		}
		
		trace("Character " + name + " not found.");
		
		bmp = new Bitmap(new BitmapData(0, 0));
		
		return bmp;
	}
	
	public static function getAreaImageDimensions(name:String):Dimension
	{
		var data:Fast = new Fast(characterData.firstChild());
		var dim:Dimension;
		
		for (char in data.nodes.CHAR)
		{
			if (char.att.NAME == name)
			{
				dim = new Dimension(Std.parseInt(char.node.ANIMATIONS.node.AREA.att.TILEWIDTH), Std.parseInt(char.node.ANIMATIONS.node.AREA.att.TILEHEIGHT));
				return dim;
			}
		}
		
		trace("Character " + name + " not found.");
		
		dim = new Dimension(0, 0);
		
		return dim;
	}
	
	public static function getAreaIdleFrames(name:String):Array<Int>
	{
		var data:Fast = new Fast(characterData.firstChild());
		var arr:Array<Int> = new Array<Int>();
		
		for (char in data.nodes.CHAR)
		{
			if (char.att.NAME == name)
			{
				arr.push(Std.parseInt(char.node.ANIMATIONS.node.AREA.node.IDLE.att.D));
				arr.push(Std.parseInt(char.node.ANIMATIONS.node.AREA.node.IDLE.att.L));
				arr.push(Std.parseInt(char.node.ANIMATIONS.node.AREA.node.IDLE.att.U));
				
				if (char.node.ANIMATIONS.node.AREA.node.IDLE.has.R)
				{
					arr.push(Std.parseInt(char.node.ANIMATIONS.node.AREA.node.IDLE.att.R));
				}
				
				return arr;
			}
		}
		
		trace("Character " + name + " not found.");
		
		for (i in 0...4)
		{
			arr.push(0);
		}
		
		return arr;
	}
	
	public static function getAreaMoveAnimations(name:String, img:Bitmap):Array<Animation>
	{
		var data:Fast = new Fast(characterData.firstChild());
		var anims:Array<Animation> = new Array<Animation>();
		
		for (char in data.nodes.CHAR)
		{
			if (char.att.NAME == name)
			{
				var delay:Int = Std.parseInt(char.node.ANIMATIONS.node.AREA.node.MOVE.att.DELAY);
				anims.push(new Animation("move_down", img, GameUtil.stringToArray(char.node.ANIMATIONS.node.AREA.node.MOVE.att.D), delay));
				anims.push(new Animation("move_left", img, GameUtil.stringToArray(char.node.ANIMATIONS.node.AREA.node.MOVE.att.L), delay));
				anims.push(new Animation("move_up", img, GameUtil.stringToArray(char.node.ANIMATIONS.node.AREA.node.MOVE.att.U), delay));
				
				if (char.node.ANIMATIONS.node.AREA.node.MOVE.has.R)
				{
					anims.push(new Animation("move_right", img, GameUtil.stringToArray(char.node.ANIMATIONS.node.AREA.node.MOVE.att.R), delay));
				}
				
				return anims;
			}
		}
		
		trace("Character " + name + " not found.");
		
		return anims;
	}
}