package com.flashartofwar.frogue.maps 
{

	/**
	 * @author jessefreeman
	 */
	public class RandomMap extends AbstractMap 
	{

		private var mapsize : Number;
		private var dirs : Array;
		private var width : Number;
		public var arr : Array;
		private var height : Number;
		private var paths : Array;
		private var rooms : Array;

		public function RandomMap(mapsize : Number)
		{
			super(this);
			generateMap(mapsize);
		}

		protected function generateMap(mapsize : Number) : void
		{
			this.mapsize = mapsize;
			this.dirs = [{x:- 1, y:0},{x:0, y:1},{x:1, y:0},{x:0, y:- 1}];
			this.width = this.height = mapsize * 2 + 3;
			this.arr = []; 
			this.paths = []; 
			this.rooms = [];
			for (var i : int = 0;i < this.height;i ++) 
			{
				var a : Array = [];
				for (var j : int = 0;j < this.width;j ++) 
				{
					a.push('#');
				}
				this.arr.push(a);
			}
			
			genMaze();
			genRooms();
			genPaths();
			clearJunk();
			makeDoors();
		}

		public function genMaze() : void 
		{
			var x : Number = 1, y : Number = 1; 
			this.arr[x][y] = ' ';
			while(1) 
			{
				var dir : Number = Math.floor(Math.random() * 4);
				for (var i : int = 0;i < 4;i ++) 
				{
					var testdir : Number = (dir + i) % 4;
					var newx : Number = x + this.dirs[testdir].x * 2;
					var newy : Number = y + this.dirs[testdir].y * 2;
					if (newx > 0 && newx < this.width && newy > 0 && newy < this.height && this.arr[newx][newy] == '#')
                break;
				}
				if (i < 4) 
				{
					x += this.dirs[testdir].x;
					y += this.dirs[testdir].y;
					this.arr[x][y] = ' ';
					x += this.dirs[testdir].x;
					y += this.dirs[testdir].y;
					this.arr[x][y] = '' + testdir;
				} 
				else 
				{ 
					//backup
					if (x == 1 && y == 1) break; 
					else 
					{
						dir = this.arr[x][y];
						this.arr[x][y] = ' ';
						x -= this.dirs[dir].x * 2;
						y -= this.dirs[dir].y * 2;
					}
				}
			}
		}

		public function toString() : String 
		{
			return this.arr.join();
		}

		//
		public function genRooms() : void 
		{
			var trycount : Number = 0;
			while (1) 
			{
				if (trycount > 10) break;
				var width : Number = Math.floor(Math.random() * 3) + 2;
				var height : Number = Math.floor(Math.random() * 3) + 2;
				var x1 : Number = Math.floor(Math.random() * (this.mapsize - width)) * 2 + 1;
				var y1 : Number = Math.floor(Math.random() * (this.mapsize - height)) * 2 + 1;
				var x2 : Number = x1 + width * 2;
				var y2 : Number = y1 + height * 2;
				room = new Room(x1, y1, x2, y2);
				for (var i : int = 0;i < this.rooms.length;i ++) 
				{
					if (room.intersects(this.rooms[i])) break;
				}
				if (i == this.rooms.length) 
				{
					this.rooms.push(room);
					trycount = 0;
				} 
				else 
				{
					trycount ++;
				}
			}
			for (i = 0;i < this.rooms.length;i ++) 
			{
				var room : Room = this.rooms[i];
				for (var x : Number = room.x1;x <= room.x2;x ++) 
				{
					for (var y : Number = room.y1;y <= room.y2;y ++) 
					{
						this.arr[x][y] = 'R';
					}
				}
			}
		}

		//
		public function findOtherEnd(room : Room, x : Number, y : Number, dir : Number) : Object 
		{
			// could probably optimize this by taking steps two at a time
			var path : Array = [];
			var d : Number = 0;
			while(1) 
			{
				if (d >= 4) 
				{ 
					// out of options, back up
					if (path.length < 2) return null;
					var back : Object = path.pop();
					x = back.x; 
					y = back.y;
					dir = back.dir;
					d = back.nextdir + 1;
					continue;
				}
		
				if (d == 2) d ++; // don't look "back"
				var tmpdir : Number = (dir + d) % 4;
				var tmpx : Number = x + this.dirs[tmpdir].x;
				var tmpy : Number = y + this.dirs[tmpdir].y;
				if (this.arr[tmpx][tmpy] == ' ') 
				{
					path.push({x: x, y: y, dir: dir, nextdir: d});
					x = tmpx + this.dirs[tmpdir].x; 
					y = tmpy + this.dirs[tmpdir].y;
					dir = tmpdir;
					d = 0;
					if (this.arr[x][y] == 'R') 
					{
						for (var rn = 0;rn < this.rooms.length;rn ++) 
						{
							if (this.rooms[rn].contains(x, y)) break;
						}
						if (this.rooms[rn] != room) 
						{
							path.push({x: x, y: y, dir: dir, nextdir: d});
							return { end: this.rooms[rn], path: path };
						}
		
						d = 5; // force a "back up"
					}
				}
			else d ++;
			}
			return { end: null, path: null };
		}

		//
		public function checkPath(room : Room, path : Object) 
		{
			if (path == null || path.path == null || path.end == null) return;
		
			if (room.connected(path.end) && Math.floor(Math.random() * 5)) return;
		
			room.connectedRooms[path.end] = path.end;
			path.end.connectedRooms[room] = room;
			this.paths.push(path);
		
			var newpath = [];
			// fill in the missing steps
			for (var i = 1;i < path.path.length;i ++) 
			{
				var step = path.path[i];
				newpath.push({
			    x: step.x - this.dirs[step.dir].x, y: step.y - this.dirs[step.dir].y, dir: step.dir
			});
				newpath.push({x: step.x, y: step.y, dir: step.dir});
			}
			newpath.pop();
			path.path = newpath;
		
			// proper path, draw it in
			for (var i = 0;i < path.path.length;i ++) 
			{
				this.arr[path.path[i].x][path.path[i].y] = 'P';
			}
		}

		//
		public function genPaths() : void 
		{
			for (var i : int = 0;i < this.rooms.length;i ++) 
			{
				var room : Room = this.rooms[i], edges = room.edges();
				for (var e = 0;e < edges.length;e ++) 
				{
					var edge = edges[e];
					if (this.arr[edge.x + this.dirs[edge.dir].x][edge.y + this.dirs[edge.dir].y] == ' ')
	    			this.checkPath(room, this.findOtherEnd(room, edge.x, edge.y, edge.dir));
				}
			}
		}

		//
		public function clearJunk() : void 
		{
			for(var x : int = 0;x < this.width;x ++) 
			{
				for (var y : int = 0;y < this.height;y ++) 
				{
					if (this.arr[x][y] == ' ') this.arr[x][y] = '#';
					if (this.arr[x][y] != '#') this.arr[x][y] = ' ';
				}
			}
		}

		//
		public function randomDoor() : String 
		{
			var d : Number = Math.random();
			if (d < .3) return ' ';
			if (d < .7) return '|';
			if (d < .9) return '=';
			return '+';
		}

		//
		public function makeDoors() : void 
		{
			for (var i : int = 0;i < this.paths.length;i ++) 
			{
				var path = this.paths[i].path;
				if (Math.random() < .05) 
				{
					this.arr[path[0].x][path[0].y] = 'S';
					this.arr[path[path.length - 1].x][path[path.length - 1].y] = 'S';
				} 
				else 
				{
					this.arr[path[0].x][path[0].y] = this.randomDoor();
					this.arr[path[path.length - 1].x][path[path.length - 1].y] = this.randomDoor();
				}

				while (Math.random() < .04) 
				{ 
					// collapse(s)
					var i = Math.floor(Math.random() * path.length);
					this.arr[path[i].x][path[i].y] = '#';
				}
			}
		}
	}
}