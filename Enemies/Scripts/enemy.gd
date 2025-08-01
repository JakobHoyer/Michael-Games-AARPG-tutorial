class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction : Vector2)
signal enemy_damaged(hurt_box : HurtBox)
signal enemy_destroyed(hurt_box : HurtBox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp : int = 3

var direction : Vector2 = Vector2.ZERO
var cardinal_direction : Vector2 = Vector2.DOWN
var player : Player
var invulnerable : bool = false

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var hit_box : HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

func _ready() -> void:
	state_machine.initialize(self)
	player = PlayerManager.player # this assumes that the player is spawned before enemies.
	hit_box.damaged.connect(_take_damage)


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	move_and_slide()


func set_direction(_new_direction) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_direction = DIR_4[direction_id]
	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	direction_changed.emit(new_direction)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1       # scale walking animation
	
	return true


func update_animation(state : String) -> void:
	animation_player.play(state + "_" + animation_direction())


func animation_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"


func _take_damage(hurt_box : HurtBox) -> void:
	if invulnerable == true:
		return
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit(hurt_box)
	else:
		enemy_destroyed.emit(hurt_box)
