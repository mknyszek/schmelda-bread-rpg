package main.mickny.schmelda.game.battle;

import main.mickny.schmelda.data.GameData;
import main.mickny.schmelda.game.area.AreaItem;
import main.mickny.schmelda.game.battle.data.Ability;
import main.mickny.schmelda.game.battle.data.BattleEntity;
import main.mickny.schmelda.game.screen.AreaScreen;
import main.mickny.schmelda.item.Item;
import main.mickny.schmelda.util.animation.AnimatedSprite;
import main.mickny.schmelda.util.animation.Animation;
import main.mickny.schmelda.util.GameUtil;
import openfl.display.Bitmap;

class BattleEnemy extends BattleEntity
{
	private var cur_hp:Int;
	private var max_hp:Int;
	private var atk:Int;
	private var def:Int;
	private var tch:Int;
	private var spd:Int;
	private var abilities:Array<Ability>;
	private var stamina:Int;
	
	private var ai:Array<Array<String>>;
	private var wander:Bool;
	private var ranged:Bool;
	private var step:Int;
	private var prevStep:Int;
	
	private var delay:Int;
	private var moveDelay:Bool;
	private var arrived:Bool;
	private var randDestX:Int;
	private var randDestY:Int;
	private var inRange:Bool;
	private var nextAction:BattleAction;
	private var actionReady:Bool;
	private var defending:Bool;
	
	private var dropItems:Array<Item>;
	private var dropChance:Array<Int>;
	private var xpDrop:Int;
	
	public var idle:Array<Animation>;
	public var move:Array<Animation>;
	public var attack:Array<Animation>;
	public var tech:Array<Animation>;
	
	public function new(x:Float, y:Float, bmp:Bitmap, tileWidth:Int, tileHeight:Int, hp:Int, xpDrop:Int, stats:Array<String>, facing:Int, abilities:Array<Ability>, ai:Array<Array<String>>, wander:Bool, ranged:Bool,
		dropItems:Array<Item>, dropChance:Array<Int>) 
	{
		super(tileWidth, tileHeight, facing, bmp);
		this.x = x;
		this.y = y;
		this.atk = Std.parseInt(stats[0]);
		this.def = Std.parseInt(stats[1]);
		this.tch = Std.parseInt(stats[2]);
		this.spd = Std.parseInt(stats[3]);
		this.cur_hp = hp;
		this.max_hp = hp;
		this.xpDrop = xpDrop;
		this.abilities = abilities;
		this.ai = ai;
		this.wander = wander;
		this.ranged = ranged;
		this.dropItems = dropItems;
		this.dropChance = dropChance;
		step = 0;
		delay = 0;
		actionReady = false;
		defending = false;
		arrived = false;
	}
	
	//Assumes "ai" is populated.
	public function update(screen:AreaScreen, plas:Array<BattlePlayer>, curRect:BattleRectangle):Void
	{
		if (ai.length > 0 && step == prevStep && !dead)
		{
			switch(ai[step][0])
			{
				case "attack":
					if(Math.random()*100 < Std.parseInt(ai[step][2])) designateAttackAction(plas);
					step++;
					if (step >= ai.length) step = 0;
				case "idle":
					if (Math.random() * 100 < Std.parseInt(ai[step][2])) setupIdle(ai[step][1]);
					step++;
					if (step >= ai.length) step = 0;
				default:
					step = 0;
			}
		}
		
		switch(state)
		{
			case "dead":
				drop(screen);
				this.clearBitmap();
				this.active = false;
				for (pla in plas)
					if (!pla.dead)
						GameData.party[pla.getCharIndex()].gainXP(xpDrop);
			case "attack":
				if (this.animate(facingToAnimation(attack))) causeAndExitAttack();
			case "move":
				if (actionReady) queueAttack(moveToward(nextAction.target.x, nextAction.target.y, true));
				else if (delay > 0 && !arrived) arrived = moveToward(randDestX, randDestY);
				else state = "idle";
			default:
				if (wander && delay > 0 && Math.random() < 0.1) setWanderTarget(curRect);
				else if (delay > 0) this.animate(facingToAnimation(idle));
				else prevStep = step;
		}
		
		if (delay > 0)
		{
			delay--;
		}
		
		if (cur_hp <= 0)
		{
			state = "dead";
			dead = true;
		}
	}
	
	private inline function setupIdle(length:String):Void
	{
		var f:Array<String> = length.split("-");
		
		if (f.length > 1)
		{
			delay = 60 * Math.ceil(Math.random() * (Std.parseInt(f[1]) - Std.parseInt(f[0])) + Std.parseInt(f[0]));
		}
		else
		{
			delay = 60 * Std.parseInt(f[0]);
		}
		state = "idle";
	}
	
	private inline function designateAttackAction(plas:Array<BattlePlayer>):Void
	{
		if(!ranged)
		{
			state = "move";
			nextAction = new BattleAction(this, "attack", interpretTarget(plas, ai[step][1]));
			actionReady = true;
		}
		else
		{
			//Ranged attack.
		}
	}
	
	private function moveToward(x:Float, y:Float, ?stopInRange:Bool = false):Bool
	{
		this.x += vX;
		this.y += vY;
		
		if (this.x > x)
		{
			vX = -1;
		}
		else if (this.x < x)
		{
			vX = 1;
		}
		else
		{
			vX = 0;
		}
		
		if (this.y > y)
		{
			vY = -1;
		}
		else if (this.y < y)
		{
			vY = 1;
		}
		else
		{
			vY = 0;
		}
		
		updateMovementAnimation(idle, move);
		
		if (stopInRange && GameUtil.getDistance(this.x, this.y, x, y) > 20)
		{
			return false;
		}
		else if (!stopInRange && this.x != x && this.y != y)
		{
			return false;
		}
		else
		{
			vX = 0;
			vY = 0;
			return true;
		}
	}
	
	private inline function queueAttack(confirm:Bool):Void
	{
		if (confirm)
		{
			BattleHandler.addToBattleQueue(nextAction);
			actionReady = false;
		}
		return;
	}
	
	private function interpretTarget(plas:Array<BattlePlayer>, indicator:String):BattlePlayer
	{
		var bpla:BattlePlayer = plas[0];
		
		switch(indicator)
		{
			case "closest":
				for (pla in plas)
					if (GameUtil.getDistance(this.x, this.y, pla.x, pla.y) < GameUtil.getDistance(this.x, this.y, bpla.x, bpla.y) && !pla.dead) 
						bpla = pla;
			case "furthest":
				for (pla in plas)
					if (GameUtil.getDistance(this.x, this.y, pla.x, pla.y) > GameUtil.getDistance(this.x, this.y, bpla.x, bpla.y) && !pla.dead) 
						bpla = pla;
		}
		
		return bpla;
	}
	
	private function causeAndExitAttack():Void
	{
		nextAction.target.takeDamage(Math.ceil(atk * 5));
		prevStep = step;
		BattleHandler.resetActivity();
	}
	
	private function setWanderTarget(rect:BattleRectangle):Void
	{
		randDestX = Math.ceil(Math.random()*(rect.width - 15) + rect.x + 15);
		randDestY = Math.ceil(Math.random()*(rect.height - 15) + rect.y + 15);
		arrived = false;
		state = "move";
	}
	
	private function drop(screen:AreaScreen):Void
	{
		var i:Int = 0;
		for (item in dropItems)
		{
			if (Math.random() * 100 < dropChance[i])
			{
				screen.addAreaItem(new AreaItem(this.x, this.y, item.getID(), item.getAmount(), this.facing), screen.getChildIndex(this)-1);
			}
			i++;
		}
	}
	
	public override function takeDamage(rawDamage:Int, ?ignoreDefense:Bool = false, ?ranged:Bool = false):Void
	{
		if (ignoreDefense)
		{
			cur_hp -= rawDamage;
		}
		else
		{
			cur_hp -= Math.ceil(rawDamage - this.def * Math.pow(rawDamage, (1.0 / 3.0)));
		}
		
		if (cur_hp <= 0)
		{
			dead = true;
			state = "dead";
		}
	}
}