package main.mickny.schmelda.item;

class Item 
{
	private var id:Int;
	private var count:Int;
	
	public function new(id:Int, count:Int) 
	{
		this.id = id;
		this.count = count;
	}
	
	public function getID():Int
	{
		return id;
	}
	
	public function getAmount():Int
	{
		return count;
	}
}