package com.flashartofwar.frogue.maps 
{
	import com.flashartofwar.frogue.enum.TilesEnum;

	import flash.geom.Point;

	/**
	 * @author jessefreeman
	 */
	public class AbstractMap implements IMap
	{

		protected var mapsize : Number;
		protected var dirs : Array;
		protected var width : Number;
		protected var height : Number;
		protected var paths : Array;
		protected var rooms : Array;
		protected var _tiles : Array;
		protected var autoAddTiles : Boolean = true;

		public function AbstractMap(self : AbstractMap) 
		{
			if(! self)
				throw new Error("Can not create AbstractMap, please extend.");
		}

		public function getTileType(position : Point) : String
		{
			return tiles[position.y][position.x];
		}

		public function canEnter(position : Point) : Boolean
		{
			return TilesEnum.isImpassable(getTileType(position));
		}

		public function get tiles() : Array
		{
			return _tiles.slice();
		}

		public function set tiles(value : Array) : void
		{
			_tiles = value.slice();
		}

		public function getSurroundingTiles(center : Point, horizontalRange : Number, verticalRange : Number) : Array
		{
			
			var range : Array = [];
			var i : int;

			for(i = 0;i < verticalRange;i ++)
			{
				range.push(getTilesInRow(center.y + i, center.x, horizontalRange));
			}
			
			return range;
		}

		protected function getTilesInRow(i : int, start : Number, end : Number) : Array
		{
			
			var offset : Number = 0;
			if(start < 0)
			{
				offset = start * - 1;
				start = 0;
			}
			
			var row : Array = _tiles[i] as Array;
			
			var total : int = row.length;
			
			var length : Number = end + start + offset;
						
			var tiles : Array = row.slice(start, end + start + offset);
			
			var leftOver : Number = length > total ? length - tiles.length : 0;
			
			if(autoAddTiles && (leftOver > 0))
			{
				for (i = 0;i < leftOver;i ++)
				{
					tiles.push("X");
				}
			}
			return tiles;
		}

		public function toString() : String
		{
			var stringMap : String = "";
			var total : int = _tiles.length;
			var i : int;
			// Render Map
			for (i = 0;i < total;i ++) 
			{
				stringMap = stringMap + (_tiles[i] as Array).join() + "\n";
			}
			
			return stringMap;
		}
		
//		protected function calculateOffset(start:Number, length:Number):Number
//		{
//			var result:Number = 	
//		}
	}
}
