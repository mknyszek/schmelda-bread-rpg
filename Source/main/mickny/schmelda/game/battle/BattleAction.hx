package main.mickny.schmelda.game.battle;

import main.mickny.schmelda.game.battle.data.BattleEntity;

class BattleAction
{
	public var entity:BattleEntity;
	public var move:String;
	public var target:BattleEntity;
	
	public function new (entity:BattleEntity, move:String, target:BattleEntity) 
	{
		this.entity = entity;
		this.move = move;
		this.target = target;
	}
}