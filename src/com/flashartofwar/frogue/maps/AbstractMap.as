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
			
			var range:Array = [];
			var i:int;
			var offsetX:int;
			var offsetY:int;
			for(i = 0; i < verticalRange; i++)
			{
				offsetX = center.x;
				offsetY = center.y + i;
				range.push(_tiles[offsetY].slice(offsetX,horizontalRange+center.x));
			}
			
			return range;
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
	}
}
