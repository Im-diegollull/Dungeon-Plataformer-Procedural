extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar
@onready var room_label: Label = $RoomLabel


func set_hp(hp: int, max_hp: int) -> void:
	health_bar.max_value = max_hp
	health_bar.value = hp


func set_room(current: int, total: int) -> void:
	room_label.text = "Sala %d/%d" % [current, total]
