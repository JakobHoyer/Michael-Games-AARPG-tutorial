extends Node2D

func _ready() -> void:
	visible = false # dont want to see it in game
	if PlayerManager.player_spawned == false:
		PlayerManager.set_player_position(global_position) # set player position to this nodes position
		PlayerManager.player_spawned = true
	pass
