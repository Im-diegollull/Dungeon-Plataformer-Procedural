extends Node2D

const TILE_SIZE: int = 16
const ENEMY_SCENE: PackedScene = preload("res://scenes/enemies/Enemy.tscn")
const ENEMY_MARGIN_TILES: int = 2

@onready var tilemap: TileMapLayer = $DungeonTileMap
@onready var player: CharacterBody2D = $Player


func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var generator := DungeonGenerator.new(rng)
	var layout: DungeonGenerator.Layout = generator.generate()
	DungeonPainter.paint(tilemap, layout, rng)

	var spawn_cell: Vector2i = layout.start_cell
	player.position = Vector2(
		spawn_cell.x * TILE_SIZE + TILE_SIZE / 2.0,
		spawn_cell.y * TILE_SIZE - 14.0
	)

	_spawn_enemies(layout)


func _spawn_enemies(layout: DungeonGenerator.Layout) -> void:
	for i in range(1, layout.rooms.size()):
		var room: Rect2i = layout.rooms[i]
		var floor_y: int = room.position.y + room.size.y
		var left_tile: int = room.position.x + ENEMY_MARGIN_TILES
		var right_tile: int = room.position.x + room.size.x - ENEMY_MARGIN_TILES

		var enemy: CharacterBody2D = ENEMY_SCENE.instantiate()
		enemy.patrol_left_x = left_tile * TILE_SIZE
		enemy.patrol_right_x = right_tile * TILE_SIZE
		enemy.position = Vector2(
			(left_tile + right_tile) / 2.0 * TILE_SIZE,
			floor_y * TILE_SIZE - 7.0
		)
		add_child(enemy)
