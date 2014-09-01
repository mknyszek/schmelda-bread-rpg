package main.mickny.schmelda.data;

import openfl.Assets;
import openfl.text.TextFormat;
import openfl.text.Font;
import haxe.xml.Fast;
import openfl.text.TextFormatAlign;
	
class ScriptData
{
	private static var format:TextFormat;
	private static var doubleFormat:TextFormat;
	private static var centerFormat:TextFormat;
	private static var rightFormat:TextFormat;
	private static var HUDFormat:TextFormat;
	private static var HUDShadowFormat:TextFormat;
	private static var font:Font;
	private static var scriptData:Xml;
		
	public static function init():Void
	{
		font = Assets.getFont("assets/font/game.ttf");
		
		format = new TextFormat();
		format.font = font.fontName;
		format.color = 0xE2E6E9;
		format.size = 16;
		
		doubleFormat = new TextFormat();
		doubleFormat.font = font.fontName;
		doubleFormat.color = 0xE2E6E9;
		doubleFormat.size = 32;
		
		centerFormat = new TextFormat();
		centerFormat.font = font.fontName;
		centerFormat.color = 0xE2E6E9;
		centerFormat.size = 16;
		centerFormat.align = TextFormatAlign.CENTER;
		
		rightFormat = new TextFormat();
		rightFormat.font = font.fontName;
		rightFormat.color = 0xE2E6E9;
		rightFormat.size = 16;
		rightFormat.align = TextFormatAlign.RIGHT;
		rightFormat.leading = 2;
		
		HUDFormat = new TextFormat();
		HUDFormat.font = font.fontName;
		HUDFormat.color = 0xE2E6E9;
		HUDFormat.size = 16;
		HUDFormat.align = TextFormatAlign.RIGHT;
		
		HUDShadowFormat = new TextFormat();
		HUDShadowFormat.font = font.fontName;
		HUDShadowFormat.color = 0x1A1A1A;
		HUDShadowFormat.size = 16;
		HUDShadowFormat.align = TextFormatAlign.RIGHT;
		
		var rawData:String = Assets.getText("assets/data/scriptdata.xml");
		scriptData = Xml.parse(rawData);
	}
	
	public static function getFormat():TextFormat
	{
		return format;
	}
	
	public static function getDoubleFormat():TextFormat
	{
		return doubleFormat;
	}
	
	public static function getCenterFormat():TextFormat
	{
		return centerFormat;
	}
	
	public static function getRightFormat():TextFormat
	{
		return rightFormat;
	}
	
	public static function getHUDFormat():TextFormat
	{
		return HUDFormat;
	}
	
	public static function getHUDShadowFormat():TextFormat
	{
		return HUDShadowFormat;
	}
	
	public static function getScriptForObject(id:String, objName:String):Array<String>
	{
		var data:Fast = new Fast(scriptData.firstChild());
		var out:Array<String> = new Array<String>();
		
		for(map in data.nodes.MAP)
		{
			if (map.att.ID == id)
			{
				for (object in map.nodes.OBJECT)
				{
					if (object.att.NAME == objName)
					{
						for (page in object.nodes.PAGE)
						{
							out.push(page.innerData);
						}
					}
				}
			}
		}
		
		return out;
	}
}