extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save : Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		position_x = 0,
		position_y = 0,
	},
	inventory = [],
	persistence = [
		'level01/treasurechest01/open'
	],
	quests = [],
}


func save_game() -> void:
	update_scene_path()
	update_player_data()
	update_item_data()
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()
	print("save_game")


func load_game() -> void:
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dictionary : Dictionary = json.get_data() as Dictionary
	current_save = save_dictionary
	
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	await LevelManager.level_load_started
	
	var player_position : Vector2 = Vector2(current_save.player.position_x, current_save.player.position_y)
	PlayerManager.set_player_position(player_position)
	PlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)
	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)
	await LevelManager.level_loaded
	game_loaded.emit()
	
	print("load_game")


func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.position_x = p.global_position.x
	current_save.player.position_y = p.global_position.y


func update_scene_path() -> void:
	# find the path by finding the level node
	var path : String = ""
	for c in get_tree().root.get_children():
		if c is Level: # should only have one (as we release others the player is not on)
			path = c.scene_file_path
	current_save.scene_path = path


func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()


func add_persistent_value(value : String) -> void:
	if check_persistent_value(value) == false:
		current_save.persistence.append(value)


func check_persistent_value(value : String) -> bool:
	var persistentArray = current_save.persistence as Array
	return persistentArray.has(value)
