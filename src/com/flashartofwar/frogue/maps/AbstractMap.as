package com.flashartofwar.frogue.maps 
{
	import com.flashartofwar.frogue.enum.TilesEnum;
	import flash.geom.Point;

	/**
	 * @author jessefreeman
	 */
	public class AbstractMap implements IMap
	{

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

		public function getSurroundingTiles(center : Point, horizontalRange : Number, verticalRange : Number) : Array
		{
			// TODO: Auto-generated method stub
			return null;
		}

		public function set tiles(value : Array) : void
		{
			_tiles = value.slice();
		}
	}
}
