package com.flashartofwar.frogue.maps 
{
	import flash.geom.Point;

	/**
	 * @author jessefreeman
	 */
	public interface IMap 
	{

		function set tiles(tiles : Array) : void;

		function get tiles() : Array;
		
		function getSurroundingTiles(center : Point, horizontalRange : Number, verticalRange : Number) : Array;

		function getTileType(position : Point) : String;

		function canEnter(position : Point) : Boolean;
	}
}
