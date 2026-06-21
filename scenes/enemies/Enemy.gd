extends CharacterBody2D

enum State { IDLE, PATROL, CHASE, ATTACK }

const SPEED: float = 80.0
const CHASE_SPEED: float = 120.0
const GRAVITY: float = 980.0
const DETECTION_RANGE: float = 100.0
const LOSE_RANGE: float = 140.0
const ATTACK_RANGE: float = 18.0

const MAX_HP: int = 30
const CONTACT_DAMAGE: int = 10
const ATTACK_COOLDOWN: float = 1.0
const KNOCKBACK_FORCE: float = 200.0

var patrol_left_x: float = 0.0
var patrol_right_x: float = 0.0
var patrol_direction: float = 1.0
var state: State = State.PATROL
var player: Node2D = null

var hp: int = MAX_HP
var attack_cooldown_remaining: float = 0.0

@onready var sprite: AnimatedSprite2D = $Sprite


func _ready() -> void:
	add_to_group("enemies")
	if patrol_left_x == 0.0 and patrol_right_x == 0.0:
		patrol_left_x = position.x - 48.0
		patrol_right_x = position.x + 48.0
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	attack_cooldown_remaining = max(0.0, attack_cooldown_remaining - delta)

	_update_state()

	match state:
		State.PATROL:
			_process_patrol()
		State.CHASE:
			_process_chase()
		State.ATTACK:
			velocity.x = 0.0
			_try_attack()
		State.IDLE:
			velocity.x = 0.0

	move_and_slide()
	_update_animation()


func _update_state() -> void:
	if player == null:
		state = State.PATROL
		return

	var distance: float = global_position.distance_to(player.global_position)

	match state:
		State.PATROL, State.IDLE:
			if distance < DETECTION_RANGE:
				state = State.CHASE
		State.CHASE:
			if distance < ATTACK_RANGE:
				state = State.ATTACK
			elif distance > LOSE_RANGE:
				state = State.PATROL
		State.ATTACK:
			if distance > ATTACK_RANGE:
				state = State.CHASE


func _process_patrol() -> void:
	velocity.x = patrol_direction * SPEED
	if position.x <= patrol_left_x:
		patrol_direction = 1.0
	elif position.x >= patrol_right_x:
		patrol_direction = -1.0


func _process_chase() -> void:
	var direction: float = sign(player.global_position.x - global_position.x)
	velocity.x = direction * CHASE_SPEED


func _try_attack() -> void:
	if attack_cooldown_remaining <= 0.0 and player != null and player.has_method("take_damage"):
		player.take_damage(CONTACT_DAMAGE, global_position)
		attack_cooldown_remaining = ATTACK_COOLDOWN


func take_damage(amount: int, source_position: Vector2) -> void:
	hp -= amount

	var knockback_dir: float = sign(global_position.x - source_position.x)
	velocity.x = knockback_dir * KNOCKBACK_FORCE
	velocity.y = -120.0

	if hp <= 0:
		queue_free()


func _update_animation() -> void:
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
	sprite.play("run" if abs(velocity.x) > 1.0 else "idle")
