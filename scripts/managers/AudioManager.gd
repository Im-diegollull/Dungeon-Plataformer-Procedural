extends Node

var _jump: AudioStreamPlayer
var _player_hurt: AudioStreamPlayer
var _player_death: AudioStreamPlayer
var _enemy_death: AudioStreamPlayer


func _ready() -> void:
	_jump = _make_player("res://assets/audio/jump.wav")
	_player_hurt = _make_player("res://assets/audio/Hurt.wav")
	_player_death = _make_player("res://assets/audio/random.wav")
	_enemy_death = _make_player("res://assets/audio/explosion.wav")


func _make_player(path: String) -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.stream = load(path)
	add_child(p)
	return p


func play_jump() -> void:
	_jump.play()


func play_player_hurt() -> void:
	_player_hurt.play()


func play_player_death() -> void:
	_player_death.play()


func play_enemy_death() -> void:
	_enemy_death.play()
