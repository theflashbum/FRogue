package com.flashartofwar.frogue.maps 
{
	import org.flexunit.Assert;

	/**
	 * @author jessefreeman
	 */
	public class MapTest 
	{

		[Test]

		public function testConstructorUsesCleanArray() : void
		{
			var tiles : Array = [["#","#","#","#"],["#","#","#","#"],["#","#","#","#"],["#","#","#","#"]];
			var map : Map = new Map(tiles);
			tiles.push(["#","#","#","#"]);
			Assert.assertEquals(map.tiles.length, 4);
		}

		[Test]

		public function testAddRow() : void
		{
			var map : Map = new Map();
			map.addRow(["#","#","#","#"]);
			Assert.assertEquals(map.tiles.length, 1);
		}

		[Test]

		public function testRemoveRow() : void
		{
			var map : Map = new Map([["#","#","#","#"], ["#"," "," ","#"], ["#","#","#","#"]]);
			map.removeRow(0);
			Assert.assertEquals((map.tiles[0] as Array).join(), "#, , ,#");
		}
	}
}
