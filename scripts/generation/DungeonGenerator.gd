extends RefCounted
class_name DungeonGenerator

const ROOM_HEIGHT: int = 9
const MIN_ROOM_WIDTH: int = 10
const MAX_ROOM_WIDTH: int = 16
const MIN_CORRIDOR_WIDTH: int = 3
const MAX_CORRIDOR_WIDTH: int = 5
const MAX_ELEVATION_CHANGE: int = 2
const MIN_ROOMS: int = 4
const MAX_ROOMS: int = 6

class Layout:
	var floor_row: Dictionary = {}  # x (int) -> y (int), tile-space floor height per column
	var rooms: Array[Rect2i] = []   # tile-space room bounds, for spawning enemies/items later
	var total_width: int = 0
	var start_cell: Vector2i = Vector2i.ZERO

var rng: RandomNumberGenerator


func _init(p_rng: RandomNumberGenerator) -> void:
	rng = p_rng


func generate() -> Layout:
	var layout := Layout.new()
	var room_count: int = rng.randi_range(MIN_ROOMS, MAX_ROOMS)
	var cursor_x: int = 0
	var baseline_y: int = 0

	for i in range(room_count):
		var width: int = rng.randi_range(MIN_ROOM_WIDTH, MAX_ROOM_WIDTH)
		for x in range(cursor_x, cursor_x + width):
			layout.floor_row[x] = baseline_y
		layout.rooms.append(Rect2i(cursor_x, baseline_y - ROOM_HEIGHT, width, ROOM_HEIGHT))
		cursor_x += width

		if i < room_count - 1:
			var corridor_width: int = rng.randi_range(MIN_CORRIDOR_WIDTH, MAX_CORRIDOR_WIDTH)
			var elevation_change: int = rng.randi_range(-MAX_ELEVATION_CHANGE, MAX_ELEVATION_CHANGE)
			for step in range(corridor_width):
				var t: float = float(step) / float(corridor_width - 1) if corridor_width > 1 else 1.0
				layout.floor_row[cursor_x + step] = baseline_y + int(round(elevation_change * t))
			cursor_x += corridor_width
			baseline_y += elevation_change

	layout.total_width = cursor_x
	var first_room: Rect2i = layout.rooms[0]
	var spawn_x: int = first_room.position.x + 2
	layout.start_cell = Vector2i(spawn_x, layout.floor_row[spawn_x])
	return layout
