@tool
class_name LevelTransition extends Area2D

enum SIDE {LEFT, RIGHT, TOP, BOTTOM}

@export_file("*.tscn") var  level # we want levels
@export var target_transition_area : String = "LevelTransition"    # change for place to go
@export var center_player : bool = false

@export_category("Collision Area Settings")
@export var default_size : Vector2 = Vector2(32, 32) # normal grid size
@export_range(1, 12, 1, "or_greater") var size : int = 2 :
	set(_v):
		size = _v
		_update_area()

@export var side : SIDE = SIDE.LEFT:
	set(_v):
		side = _v
		_update_area()

@export var snap_to_grid : bool = false:
	set(_v):
		_snap_to_grid()

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint(): # true if in the editor
		return
	
	# Don't monitor imeadiatly as he could be on same level transition
	monitoring = false
	_place_player()
	
	await LevelManager.level_loaded # wait for finished level load before enabling monitoring
	await get_tree().process_frame
	monitoring = true
	body_entered.connect(_player_entered)
	pass

func _player_entered(_p : Node2D) -> void:
	LevelManager.load_new_level(level, target_transition_area, get_offset())
	pass

func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position(global_position + LevelManager.position_offset)
	pass

func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_position = PlayerManager.player.global_position
	
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		if center_player == true:
			offset.y = 0
		else:
			offset.y = player_position.y - global_position.y
		offset.x = 16
		if side == SIDE.LEFT:
			offset.x *= -1 # scale correct
	
	elif  side == SIDE.BOTTOM or side == SIDE.TOP:
		if center_player == true:
			offset.x = 0
		else:
			offset.x = player_position.x - global_position.x
		offset.y = 16
		if side == SIDE.TOP:
			offset.y *= -1 # scale correct
	
	return offset

func _update_area() -> void:
	var new_rect : Vector2 = default_size # posibly obsilite with default size
	var new_position : Vector2 = Vector2.ZERO
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16
	
	if collision_shape_2d == null:
		collision_shape_2d = get_node("CollisionShape2D")
	
	collision_shape_2d.shape.size = new_rect
	collision_shape_2d.position = new_position
	pass

func _snap_to_grid() -> void:
	position.x = round( position.x / 16) * 16
	position.y = round( position.x / 16) * 16
