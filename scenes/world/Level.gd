extends Node2D

const TILE_SIZE: int = 16

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
