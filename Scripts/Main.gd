extends Node2D


var Room = preload("res://Scenes/room.tscn") # The room obj.

var tileSize = 16 
var numRooms = 16 
var minSize = 4
var maxSize = 10
var hSpread = 400 # This is how room will spread over screen's width.
var cull = 0.5 # The chance of cutting the room to get more space.

var path

@onready var Map = $TileMap


func _ready():
	# Randomizing the system's nums for random generation and creating rooms.
	randomize()
	makeRooms()


func makeRooms():
	# Making *numRooms* rooms and adding it to Rooms node. Then waiting a bit.
	for i in range(numRooms):
		var pos = Vector2(randi_range(-hSpread, hSpread), 0)
		var room = Room.instantiate()
		var widht = minSize + randi() % (maxSize - minSize)
		var height = minSize + randi() % (maxSize - minSize)
		room.make_room(pos, Vector2(widht, height) * tileSize)
		$Rooms.add_child(room)
	await(get_tree().create_timer(1.1).timeout)

	# KILLING ROOMS. And writing positions of alive.
	var roomPositions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.freeze = true
			roomPositions.append(room.position)

	await get_tree().process_frame # Wait for this shit.
	path = findMST(roomPositions) # Creating minimum spanning tree.


func _draw():
	# This func only need to get more visual understanding of shit happening in the game.
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(32, 228, 0), false)

	if path:
		for p in path.get_point_ids():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(pp, cp, Color(1, 1, 0), 15, true)


func _process(delta):
	queue_redraw()


func _input(event):
	# Rebuild the dungeon.
	if event.is_action_pressed("ui_select"):
		for room in $Rooms.get_children():
			room.queue_free()
		path = null
		makeRooms()
	# Remake the paths in dungeon. It doesn't help.
	if event.is_action_pressed("goida"):
		makeMap()


func findMST(nodes):
	# Finding MST with Prim's algorithm. Not so difficult. Wiki will help.
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())

	while nodes:
		var minDist = INF
		var minP = null
		var p = null

		for path1 in path.get_point_ids():
			var _path1 = path.get_point_position(path1)
			for _path2 in nodes:
				if _path1.distance_to(_path2) < minDist:
					minDist = _path1.distance_to(_path2)
					minP = _path2
					p = _path1
		var n = path.get_available_point_id()
		path.add_point(n, minP)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(minP)

	return path


func makeMap():
	# Here we creating map. Just finding the position on all rooms
	# and filling them up with tiles. Easy.
	Map.clear()
	var fullRect = Rect2()
	for room in $Rooms.get_children():
		var rect = Rect2(room.position - room.size, room.get_node("CollisionShape2D").shape.extents*2)
		fullRect = fullRect.merge(rect)
	var topleft = Map.local_to_map(fullRect.position)
	var bottomright = Map.local_to_map(fullRect.end)
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			Map.set_cell(0, Vector2i(x, y), 2,  Vector2i(0, 0), 0)

	var corridors = []
	for room in $Rooms.get_children():
		var s = (room.size / tileSize).floor()
		var pos = Map.local_to_map(room.position)
		var ul = (room.position / tileSize).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				Map.set_cell(0, Vector2i(ul.x + x, ul.y + y), 2, Vector2i(4, 6), 0)
		var p = path.get_closest_point(room.position)

		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.local_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = Map.local_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				carvePath(start, end)

		corridors.append(p)


func carvePath(start, end):
	# Don't fucking ask me what kurwa is happening there.
	# I have to fucking kurwa rewrite some shit to get this kurwa paths working.
	# Because old code calls shit that kurwa was like YOU CAN'T GET FROM ONE
	# ROOM TO ANOTHER, THERE WAS NO FUCKING KURWA WAY.
	# I think we'll have to rewrite this shit again because of
	# tilemap atlas terrain. This kurwa goida is really cool.
	# But now we have to pierdolic sie with this.
	var xDiff = sign(end.x - start.x)
	var yDiff = sign(end.y - start.y)
	if xDiff == 0: xDiff = pow(-1.0, randi() % 2)
	if yDiff == 0: yDiff = pow(-1.0, randi() % 2)
	
	var xY = start
	var yX = end
	
	if (randi() % 2) > 0:
		xY = end
		yX = start

	for x in range(start.x, end.x, xDiff):
		Map.set_cell(0, Vector2i(x, yX.y), 2, Vector2i(4, 6), 0);
		Map.set_cell(0, Vector2i(x, yX.y + yDiff), 2, Vector2i(4, 6), 0);

	for y in range(start.y, end.y, yDiff):
		Map.set_cell(0, Vector2i(xY.x, y), 2, Vector2i(4, 6), 0);
		Map.set_cell(0, Vector2i(xY.x + xDiff, y), 2, Vector2i(4, 6), 0);
