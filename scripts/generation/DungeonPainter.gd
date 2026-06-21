extends RefCounted
class_name DungeonPainter

const FLOOR_SOURCE: int = 0
const FLOOR_TILE: Vector2i = Vector2i(6, 1)
const FLOOR_TILE_ALT: Vector2i = Vector2i(0, 0)
const WALL_SOURCE: int = 1
const WALL_TILE: Vector2i = Vector2i(7, 0)


static func paint(tilemap: TileMapLayer, layout: DungeonGenerator.Layout, rng: RandomNumberGenerator) -> void:
	tilemap.clear()

	for x in range(layout.total_width):
		var floor_y: int = layout.floor_row[x]
		var floor_tile: Vector2i = FLOOR_TILE_ALT if rng.randf() < 0.2 else FLOOR_TILE
		tilemap.set_cell(Vector2i(x, floor_y), FLOOR_SOURCE, floor_tile)
		tilemap.set_cell(Vector2i(x, floor_y - DungeonGenerator.ROOM_HEIGHT), WALL_SOURCE, WALL_TILE)

	_paint_boundary_wall(tilemap, 0, layout.floor_row[0])
	var right_x: int = layout.total_width - 1
	_paint_boundary_wall(tilemap, right_x, layout.floor_row[right_x])


static func _paint_boundary_wall(tilemap: TileMapLayer, x: int, floor_y: int) -> void:
	for y in range(floor_y - DungeonGenerator.ROOM_HEIGHT, floor_y):
		tilemap.set_cell(Vector2i(x, y), WALL_SOURCE, WALL_TILE)
