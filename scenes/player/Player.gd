extends CharacterBody2D

signal hp_changed(hp: int, max_hp: int)

const SPEED: float = 200.0
const JUMP_VELOCITY: float = -400.0
const GRAVITY: float = 980.0

const MAX_HP: int = 100
const ATTACK_DAMAGE: int = 15
const ATTACK_COOLDOWN: float = 0.4
const ATTACK_ACTIVE_TIME: float = 0.15
const KNOCKBACK_FORCE: float = 250.0
const HURT_INVULNERABLE_TIME: float = 0.5

var hp: int = MAX_HP
var facing: float = 1.0
var attack_cooldown_remaining: float = 0.0
var invulnerable_remaining: float = 0.0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var weapon: Sprite2D = $Weapon
@onready var attack_hitbox: Area2D = $AttackHitbox


func _ready() -> void:
	add_to_group("player")
	attack_hitbox.body_entered.connect(_on_attack_hitbox_body_entered)
	hp_changed.emit(hp, MAX_HP)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction: float = Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		velocity.x = direction * SPEED
		facing = direction
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

	attack_cooldown_remaining = max(0.0, attack_cooldown_remaining - delta)
	invulnerable_remaining = max(0.0, invulnerable_remaining - delta)

	if Input.is_action_just_pressed("attack") and attack_cooldown_remaining <= 0.0:
		_attack()

	move_and_slide()
	_update_animation(direction)


func _attack() -> void:
	attack_cooldown_remaining = ATTACK_COOLDOWN
	weapon.position.x = abs(weapon.position.x) * facing
	weapon.flip_h = facing < 0.0
	attack_hitbox.position.x = abs(attack_hitbox.position.x) * facing
	attack_hitbox.monitoring = true

	weapon.rotation_degrees = -30.0
	var tween := create_tween()
	tween.tween_property(weapon, "rotation_degrees", 50.0, ATTACK_ACTIVE_TIME)
	tween.tween_property(weapon, "rotation_degrees", 0.0, 0.05)

	get_tree().create_timer(ATTACK_ACTIVE_TIME).timeout.connect(func() -> void:
		attack_hitbox.monitoring = false
	)


func _on_attack_hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(ATTACK_DAMAGE, global_position)


func take_damage(amount: int, source_position: Vector2) -> void:
	if invulnerable_remaining > 0.0:
		return

	hp -= amount
	invulnerable_remaining = HURT_INVULNERABLE_TIME
	hp_changed.emit(hp, MAX_HP)

	var knockback_dir: float = sign(global_position.x - source_position.x)
	velocity.x = knockback_dir * KNOCKBACK_FORCE
	velocity.y = -150.0

	if hp <= 0:
		get_tree().change_scene_to_file("res://scenes/ui/GameOver.tscn")


func _update_animation(direction: float) -> void:
	if direction != 0.0:
		sprite.flip_h = direction < 0.0

	if is_on_floor():
		sprite.play("run" if direction != 0.0 else "idle")
	else:
		sprite.play("idle")
