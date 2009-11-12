package com.flashartofwar.frogue.maps 
{
	import flash.geom.Point;

	import org.flexunit.Assert;

	import com.flashartofwar.frogue.maps.AbstractMap;

	/**
	 * @author jessefreeman
	 */
	public class AbstaractMapTest extends AbstractMap 
	{

		public function AbstaractMapTest()
		{
			super(this);
		}

		[Test]

		public function testGetTiles() : void
		{
			tiles = ["#","#","_"];
			
			var tilesCopy : Array = tiles;
			
			tilesCopy.length = 0;
			
			Assert.assertEquals('There should be 3 tiles in the array.', tiles.length, 3);
		}

		[Test]

		public function testSetTiles() : void
		{
			
			var tempTiles : Array = ["#","#","_"];
			
			tiles = tempTiles;
			
			tempTiles.length = 0;
			
			Assert.assertEquals('There should be 3 tiles in the array.', tiles.length, 3);
		}

		[Test]

		public function testCanEnter() : void
		{
			tiles = [["#","#","#"],["#","_","#"],["#","#","#"]];
			var point : Point = new Point(0, 1);
			Assert.assertTrue("Looking at " + getTileType(point) + " tile.", canEnter(point));	
		}

		[Test]

		public function testCanNotEnter() : void
		{
			tiles = [["#","#","#"],["#","_","#"],["#","#","#"]];
			var point : Point = new Point(1, 1);
			Assert.assertFalse("Looking at " + getTileType(point) + " tile.", canEnter(point));		
		}

		[Test]

		public function testGetTileType() : void
		{
			tiles = [["#","#","#"],["#","_","#"],["#","#","@"]];

			Assert.assertEquals(getTileType(new Point(1, 1)), "_");

			Assert.assertEquals(getTileType(new Point(2, 2)), "@");
		}
	}
}
