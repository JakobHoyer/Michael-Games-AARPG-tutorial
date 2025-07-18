extends Node

signal level_load_started
signal level_loaded
signal tilemap_bounds_changed(bounds : Array[Vector2])

var current_tilemap_bounds : Array[Vector2]
var target_transition : String
var position_offset : Vector2


func _ready() -> void:
	await get_tree().process_frame # wait until everything is loaded
	level_loaded.emit() # tell the first level has loaded


func change_tilemap_bounds(bounds : Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	tilemap_bounds_changed.emit(bounds)


func load_new_level(level_path : String, _target_transition : String, _position_offset : Vector2) -> void:
	
	# Pause game for a second to avoid unintentional stuff
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await SceneTransition.fade_out() # effect
	level_load_started.emit() 

	await get_tree().process_frame # wait for next process tick to make sure the old level is properly removed
	get_tree().change_scene_to_file(level_path)
	
	await SceneTransition.fade_in() # another effect
	get_tree().paused = false

	await get_tree().process_frame
	level_loaded.emit()
