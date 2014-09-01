package main.mickny.schmelda.game.screen.util;

import main.mickny.schmelda.util.GameUtil;
import main.mickny.schmelda.game.screen.util.Screen;

import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;

class Camera2D extends Rectangle
{
	private static inline var SETUP_SPEED:Int = 1;
	
	private var matrix:Matrix;
	private var prevX:Float;
	private var prevY:Float;
	
	public function new(X:Int, Y:Int) 
	{
		super(X, Y);
		
		this.width = GameUtil.scrnWidth / GameUtil.ZOOM;
		this.height = GameUtil.scrnHeight / GameUtil.ZOOM;
		
		matrix = new Matrix();
		matrix.invert();
		matrix.scale(GameUtil.ZOOM, GameUtil.ZOOM);
		prevX = this.x;
		prevY = this.y;
	}
	
	public function update(parent:Sprite):Void
	{
		this.width = GameUtil.scrnWidth / GameUtil.ZOOM;
		this.height = GameUtil.scrnHeight / GameUtil.ZOOM;
		matrix.translate(GameUtil.ZOOM*(prevX - this.x), GameUtil.ZOOM*(prevY - this.y));
		parent.transform.matrix = matrix;
		prevX = this.x;
		prevY = this.y;
	}
	
	public function reset(parent:Sprite):Void
	{
		var matrix:Matrix = new Matrix();
		parent.transform.matrix = matrix;
	}
	
	public function moveToward(parent:Sprite, x:Int, y:Int):Bool
	{
		if (this.x > x)
		{
			this.x -= SETUP_SPEED;
		}
		else if (this.x < x)
		{
			this.x += SETUP_SPEED;
		}
		
		if (this.y > y)
		{
			this.y -= SETUP_SPEED;
		}
		else if (this.y < y)
		{
			this.y += SETUP_SPEED;
		}
		
		this.update(parent);
		
		if (this.x != x || this.y != y)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
}