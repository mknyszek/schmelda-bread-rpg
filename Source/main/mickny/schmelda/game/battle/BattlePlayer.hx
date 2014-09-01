package main.mickny.schmelda.game.battle;

import main.mickny.schmelda.data.GameData;
import main.mickny.schmelda.game.battle.data.BattleEntity;
import main.mickny.schmelda.game.battle.data.Character;
import main.mickny.schmelda.util.animation.AnimatedSprite;
import main.mickny.schmelda.util.animation.Animation;
import main.mickny.schmelda.util.Dimension;
import main.mickny.schmelda.util.GameUtil;
import main.mickny.schmelda.util.KeyChecker;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class BattlePlayer extends BattleEntity
{
	private static var ATTACK_RADIUS:Int = 50;
	
	private var charIndex:Int;
	private var ready:Bool;
	private var arrowIndicator:AnimatedSprite;
	private var target:BattleEntity;
	private var stamina:Int;
	private var attackReady:Bool;
	private var ranged:Bool;
	private var rangeRadius:Sprite;
	
	private var attackStartX:Float;
	private var attackStartY:Float;
	private var attackFinishX:Float;
	private var attackFinishY:Float;
	private var orgSet:Bool;
	
	//Order is same as facing, indicies: 0 = forward, 1 = left, 2 = backwards, 3 = right
	//The 'right' or '3' animation is optional, and if not present will be covered by 'left' or '1' by changing scaleX.
	public var start:Array<Animation>;
	public var idle:Array<Animation>;
	public var move:Array<Animation>;
	public var attack1:Array<Animation>;
	public var attack2:Array<Animation>;
	public var defend:Array<Animation>;
	public var useItem:Array<Animation>;
	
	public function new(x:Float, y:Float, facing:Int, charIndex:Int, bmp:Bitmap, tile:Dimension) 
	{
		super(tile.wid, tile.hei, facing, bmp);
		
		this.x = x;
		this.y = y;
		this.charIndex = charIndex;
		
		stamina = getMaxStamina();
		ranged = false;
		orgSet = false;
		
		var radiusHeight:Int = Math.floor(ATTACK_RADIUS * 0.75);
		
		arrowIndicator = new AnimatedSprite(20, 20);
		arrowIndicator.x = 0;
		arrowIndicator.y = -1 * this.height + 10;
		this.addChild(arrowIndicator);
		
		rangeRadius = new Sprite();
		rangeRadius.graphics.beginFill(0xC74E4E, 0.4);
		rangeRadius.graphics.drawEllipse(0, 0, ATTACK_RADIUS * GameUtil.ZOOM, radiusHeight * GameUtil.ZOOM);
		rangeRadius.x = -1 * rangeRadius.width / 2;
		rangeRadius.y = -1 * GameData.party[charIndex].getBattleTileYOffset() - rangeRadius.height / 2;
		rangeRadius.visible = false;
		this.addChildAt(rangeRadius, 0);
	}
	
	public function update():Void
	{
		if (attackReady && stamina > getMaxStamina() >> 1)
		{
			if (target != null) BattleHandler.addToBattleQueue(new BattleAction(this, "attack", target));
			else trace("Target non-existent; character " + charIndex + "!");
			attackReady = false;
		}
		
		switch(state)
		{
			case "start":
				var finished:Bool = this.animate(facingToAnimation(start));
				if (finished) state = "idle";
			case "move":
				if (stamina > 0) movePlayer();
				else BattleHandler.exitMoveMode();
			case "attack":
				setOriginalPosition();
				if (target != null && !ranged && GameUtil.getDistance(this.x, this.y, target.x, target.y) > 15) moveToward(target.x, target.y, attackStartX, attackStartY);
				if (this.animate(facingToAnimation(attack1)) && target != null) causeAndExitAttack(target, false);
			case "attack2":
				if (this.animate(facingToAnimation(attack2)) && target != null) causeAndExitAttack(target, true);
			case "defend":
				this.animate(facingToAnimation(defend));
				regenStamina();
			case "return":
				if (!ranged && moveToward(attackStartX, attackStartY, attackFinishX, attackFinishY)) state = "idle";
				if (ranged) state = "idle";
			case "dead":
				//do nothing.
			default:
				this.animate(facingToAnimation(idle));
				regenStamina();
		}
		GameData.party[charIndex].updateCurrentStamina(stamina);
	}
	
	public function getImage():Bitmap
	{
		return bmp;
	}
	
	public function initAnimation():Void
	{
		this.animate(facingToAnimation(start));
	}
	
	public override function setState(state:String):Void
	{
		this.state = state;
		ready = false;
	}
	
	public function getCharIndex():Int
	{
		return charIndex;
	}
	
	public function showRange():Void
	{
		rangeRadius.visible = true;
	}
	
	public function hideRange():Void
	{
		rangeRadius.visible = false;
	}
	
	public function getRanged():Bool
	{
		return ranged;
	}
	
	public function showIndicator(bmpData:BitmapData):Void
	{
		arrowIndicator.displayFromData(bmpData, 0);
	}
	
	public function hideIndicator():Void
	{
		arrowIndicator.clearBitmap();
	}
	
	public override function takeDamage(rawDamage:Int, ?ignoreDefense:Bool = false, ?ranged:Bool = false):Void
	{
		if (ignoreDefense)
		{
			GameData.party[charIndex].addHP( -1 * rawDamage);
			addStamina( Math.ceil(-6700 * (rawDamage/GameData.party[charIndex].getMaxHP())));
		}
		else if (state == "defend")
		{
			var final:Int = GameData.party[charIndex].computeFinalDamage(rawDamage, ranged);
			var finalSta:Int = Math.ceil( -24000 * (final / GameData.party[charIndex].getMaxHP()));
			if (finalSta * -1 >= stamina)
			{
				GameData.party[charIndex].addHP( Math.ceil(-1 * ((finalSta-stamina)/finalSta) * final));
				addStamina(finalSta);
			}
			else
			{
				addStamina(finalSta);
			}
		}
		else
		{
			var final:Int = GameData.party[charIndex].computeFinalDamage(rawDamage, ranged);
			GameData.party[charIndex].addHP( -1 * final);
			addStamina( Math.ceil(-6700 * (final/GameData.party[charIndex].getMaxHP())));
		}
		
		if (GameData.party[charIndex].getCurrentHP() <= 0)
		{
			dead = true;
			state = "dead";
		}
	}
	
	public function getCurrentStamina():Int
	{
		return stamina;
	}
	
	public function getMaxStamina():Int
	{
		return Character.MAX_STAMINA;
	}
	
	public function addStamina(change:Int):Void
	{
		stamina += change;
		if (stamina > getMaxStamina())
		{
			stamina = getMaxStamina();
		}
		else if (stamina < 0)
		{
			stamina = 0;
		}
	}
	
	public function regenStamina():Void
	{
		addStamina(GameData.party[charIndex].getStaminaRegenFrame());
	}
	
	public function prepareAttack(target:BattleEntity):Void
	{
		attackReady = true;
		this.target = target;
	}
	
	private function setOriginalPosition():Void
	{
		if (!orgSet)
		{
			attackStartX = this.x;
			attackStartY = this.y;
			orgSet = true;
		}
	}
	
	private function causeAndExitAttack(target:BattleEntity, secondAttack:Bool):Void
	{
		target.takeDamage(GameData.party[charIndex].getRawDamageOutput(), false, false);
		addStamina( -4700);
		if (!ranged)
		{
			state = "return";
			attackFinishX = this.x;
			attackFinishY = this.y;
		}
		else
		{
			state = "idle";
		}
		
		BattleHandler.resetActivity();
		orgSet = false;
	}
	
	private function movePlayer():Void
	{
		this.x += vX;
		this.y += vY;
		
		if (!ready && GameUtil.key.released(KeyChecker.UP))
		{
			ready = true;
		}
		
		if (ready && GameUtil.key.pressed(KeyChecker.LEFT))
		{
			vX = -2;
		}
		else if (ready && GameUtil.key.pressed(KeyChecker.RIGHT))
		{
			vX = 2;
		}
		else
		{
			vX = 0;
		}
		
		if (ready && GameUtil.key.pressed(KeyChecker.UP))
		{
			vY = -2;
		}
		else if (ready && GameUtil.key.pressed(KeyChecker.DOWN))
		{
			vY = 2;
		}
		else
		{
			vY = 0;
		}
		
		if (vX != 0 || vY != 0)
		{
			addStamina( -22);
		}
		
		updateMovementAnimation(idle, move);
	}
	
	private function moveToward(x:Float, y:Float, x2:Float, y2:Float):Bool
	{
		this.x += vX;
		this.y += vY;
		
		var angle:Float = Math.atan2(y - y2, x - x2) + Math.PI / 2;
		
		if (GameUtil.getDistance(this.x, this.y, x, y) > 4)
		{
			vX = Math.round(3 * Math.sin(angle));
			vY = Math.round(-3 * Math.cos(angle));
			return false;
		}
		else
		{
			vX = 0;
			vY = 0;
			return true;
		}
	}
}