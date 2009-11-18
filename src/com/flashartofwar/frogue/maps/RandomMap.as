package com.flashartofwar.frogue.maps 
{

	/**
	 * The MIT License
	 * 
	 * Copyright (c) 2009 @author jessefreeman
	 * 
	 * Permission is hereby granted, free of charge, to any person obtaining a copy
	 * of this software and associated documentation files (the "Software"), to deal
	 * in the Software without restriction, including without limitation the rights
	 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	 * copies of the Software, and to permit persons to whom the Software is
	 * furnished to do so, subject to the following conditions:
	 * 
	 * The above copyright notice and this permission notice shall be included in
	 * all copies or substantial portions of the Software.
	 * 
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	 * THE SOFTWARE.
	 * 
	 */
	public class RandomMap extends AbstractMap 
	{

		/**
		 * 
		 * @param mapsize
		 */
		public function RandomMap(mapsize : Number)
		{
			super(this);
			generateMap(mapsize);
		}

		/**
		 * 
		 * @param mapsize
		 */
		protected function generateMap(mapsize : Number) : void
		{
			this.mapsize = mapsize;
			this.dirs = [{x:- 1, y:0},{x:0, y:1},{x:1, y:0},{x:0, y:- 1}];
			this.width = this.height = mapsize * 2 + 3;
			_tiles = []; 
			this.paths = []; 
			this.rooms = [];
			for (var i : int = 0;i < this.height;i ++) 
			{
				var a : Array = [];
				for (var j : int = 0;j < this.width;j ++) 
				{
					a.push('#');
				}
				_tiles.push(a);
			}
			
			genMaze();
			genRooms();
			genPaths();
			clearJunk();
			makeDoors();
		}

		/**
		 * 
		 */
		public function genMaze() : void 
		{
			var x : Number = 1, y : Number = 1; 
			_tiles[x][y] = ' ';
			while(1) 
			{
				var dir : Number = Math.floor(Math.random() * 4);
				for (var i : int = 0;i < 4;i ++) 
				{
					var testdir : Number = (dir + i) % 4;
					var newx : Number = x + this.dirs[testdir].x * 2;
					var newy : Number = y + this.dirs[testdir].y * 2;
					if (newx > 0 && newx < this.width && newy > 0 && newy < this.height && _tiles[newx][newy] == '#')
                break;
				}
				if (i < 4) 
				{
					x += this.dirs[testdir].x;
					y += this.dirs[testdir].y;
					_tiles[x][y] = ' ';
					x += this.dirs[testdir].x;
					y += this.dirs[testdir].y;
					_tiles[x][y] = '' + testdir;
				} 
				else 
				{ 
					//backup
					if (x == 1 && y == 1) break; 
					else 
					{
						dir = _tiles[x][y];
						_tiles[x][y] = ' ';
						x -= this.dirs[dir].x * 2;
						y -= this.dirs[dir].y * 2;
					}
				}
			}
		}

		/**
		 * 
		 */
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
						_tiles[x][y] = 'R';
					}
				}
			}
		}

		//
		/**
		 * 
		 * @param room
		 * @param x
		 * @param y
		 * @param dir
		 * @return 
		 */
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
				if (_tiles[tmpx][tmpy] == ' ') 
				{
					path.push({x: x, y: y, dir: dir, nextdir: d});
					x = tmpx + this.dirs[tmpdir].x; 
					y = tmpy + this.dirs[tmpdir].y;
					dir = tmpdir;
					d = 0;
					if (_tiles[x][y] == 'R') 
					{
						for (var rn : int = 0;rn < this.rooms.length;rn ++) 
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
		/**
		 * 
		 * @param room
		 * @param path
		 */
		public function checkPath(room : Room, path : Object) : void
		{
			if (path == null || path.path == null || path.end == null) return;
		
			if (room.connected(path.end) && Math.floor(Math.random() * 5)) return;
		
			room.connectedRooms[path.end] = path.end;
			path.end.connectedRooms[room] = room;
			this.paths.push(path);
		
			var newpath:Array = [];
			// fill in the missing steps
			for (var i : int = 1;i < path.path.length;i ++) 
			{
				var step:Object = path.path[i];
				newpath.push({
			    x: step.x - this.dirs[step.dir].x, y: step.y - this.dirs[step.dir].y, dir: step.dir
			});
				newpath.push({x: step.x, y: step.y, dir: step.dir});
			}
			newpath.pop();
			path.path = newpath;
		
			// proper path, draw it in
			for (i = 0;i < path.path.length;i ++) 
			{
				_tiles[path.path[i].x][path.path[i].y] = 'P';
			}
		}

		//
		/**
		 * 
		 */
		public function genPaths() : void 
		{
			for (var i : int = 0;i < this.rooms.length;i ++) 
			{
				var room : Room = this.rooms[i];
				var edges : Array = room.edges();
				for (var e : int = 0;e < edges.length;e ++) 
				{
					var edge : Object = edges[e];
					if (_tiles[edge.x + this.dirs[edge.dir].x][edge.y + this.dirs[edge.dir].y] == ' ')
	    			this.checkPath(room, this.findOtherEnd(room, edge.x, edge.y, edge.dir));
				}
			}
		}

		//
		/**
		 * 
		 */
		public function clearJunk() : void 
		{
			for(var x : int = 0;x < this.width;x ++) 
			{
				for (var y : int = 0;y < this.height;y ++) 
				{
					if (_tiles[x][y] == ' ') _tiles[x][y] = '#';
					if (_tiles[x][y] != '#') _tiles[x][y] = ' ';
				}
			}
		}

		//
		/**
		 * 
		 * @return 
		 */
		public function randomDoor() : String 
		{
			var d : Number = Math.random();
			if (d < .3) return ' ';
			if (d < .7) return '|';
			if (d < .9) return '=';
			return '+';
		}

		//
		/**
		 * 
		 */
		public function makeDoors() : void 
		{
			for (var i : int = 0;i < this.paths.length;i ++) 
			{
				var path : Object = this.paths[i].path;
				if (Math.random() < .05) 
				{
					_tiles[path[0].x][path[0].y] = 'S';
					_tiles[path[path.length - 1].x][path[path.length - 1].y] = 'S';
				} 
				else 
				{
					_tiles[path[0].x][path[0].y] = this.randomDoor();
					_tiles[path[path.length - 1].x][path[path.length - 1].y] = this.randomDoor();
				}

				while (Math.random() < .04) 
				{ 
					// collapse(s)
					i = Math.floor(Math.random() * path.length);
					_tiles[path[i].x][path[i].y] = '#';
				}
			}
		}
	}
}
