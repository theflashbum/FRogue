package com.flashartofwar.frogue.maps 
{
	import com.flashartofwar.frogue.maps.AbstractMap;

	/**
	 * @author jessefreeman
	 */
	public class Map extends AbstractMap 
	{

		public function Map(tiles:Array = null)
		{
			if(tiles)
				_tiles = tiles.slice();
			else
				_tiles = [];
			super(this);
			
		}

		public function addRow(tiles : Array) : void
		{
			_tiles.push(tiles);
		}
		
		public function removeRow(id:int):void
		{
			_tiles.splice(id,1);
		}
	}
}
