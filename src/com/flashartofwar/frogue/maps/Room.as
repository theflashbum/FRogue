package com.flashartofwar.frogue.maps {
	import flash.utils.Dictionary;

	/**
	 * @author jessefreeman
	 */
	public class Room {

		public var x1 : Number;
		public var y1 : Number;
		public var x2 : Number;
		public var y2 : Number;
		public var connectedRooms : Object;

		public function get width() : Number { 
			return this.x2 - this.x1;
		};

		public function get height() : Number { 
			return this.y2 - this.y1;
		};

		public function get top() : Number { 
			return this.y1; 
		};

		public function get left() : Number { 
			return this.x1;
		};

		public function Room(x1 : Number, y1 : Number, x2 : Number, y2 : Number) {
			if (x1 > x2) { 
				var x : Number = x1; 
				x1 = x2; 
				x2 = x; 
			}
			if (y1 > y2) { 
				var y : Number = y1; 
				y1 = y2; 
				y2 = y; 
			}
			this.x1 = x1; 
			this.y1 = y1;
			this.x2 = x2; 
			this.y2 = y2;
			this.connectedRooms = new Object();
		}

		//
		public function toString() : String {
			return '[room ' + this.x1 + ', ' + this.y1 + ', ' + this.x2 + ', ' + this.y2 + ']';
		}

		//
		public function intersects(room : Room) : Boolean {
			return this.x1 <= room.x2 && this.x2 >= room.x1 && this.y1 <= room.y2 && this.y2 >= room.y1;
		}

		//
		public function contains(x : Number, y : Number) : Boolean {
			return x >= this.x1 && x <= this.x2 && y >= this.y1 && y <= this.y2;
		}

		//
		
		//

		//
		public function connected(otherroom : Room, seenlist : Dictionary = null) : Boolean {
			if (this.connectedRooms[otherroom]) return true;
			if (!seenlist) { 
				seenlist = new Dictionary(true);
				seenlist[this] = true;
			}
			if (seenlist[otherroom]) return false;
			seenlist[otherroom] = true;
			for(var i:Object in otherroom.connectedRooms) {
				if (this.connected(otherroom.connectedRooms[i], seenlist)) return true;
			}
			return false;
		}

		//
		public function edges() : Array {
			var e : Array = [];
			for (var x : Number = this.x1;x <= this.x2;x++) {
				e.push({x: x, y: this.y1, dir: 3});
				e.push({x: x, y: this.y2, dir: 1});
			}
			for (var y : Number = this.y1;y <= this.y2;y++) {
				e.push({x: this.x1, y: y, dir: 0});
				e.push({x: this.x2, y: y, dir: 2});
			}
			return e;
		}
	}
}
