extends Node

const PLAYER = preload("res://Player/player.tscn")
const INVENTORY_DATA = preload("res://GUI/PlayerMenu/Inventory/player_inventory.tres")

signal interact_pressed

var player : Player
var player_spawned : bool = false

func _ready() -> void:
	add_player_instance()
	# fail safe if player did not spawn
	await get_tree().create_timer(0.3).timeout
	player_spawned = true


func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player) # add player to scene


func set_health(hp : int, max_hp : int) -> void:
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp(0)


func set_player_position(_new_pos : Vector2) -> void:
	player.global_position = _new_pos


func set_as_parent(_p : Node2D) -> void:
	if player.get_parent(): # dont get issues with old parent
		player.get_parent().remove_child(player)
	_p.add_child(player)


func unparent_player(_p : Node2D) -> void:
	_p.remove_child(player)
