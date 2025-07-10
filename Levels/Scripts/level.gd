class_name Level extends Node2D

func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(_free_level)
	pass

func _free_level() -> void:
	PlayerManager.unparent_player(self) # ensure that the player does not get removed when removing level (as it is part of level scene as child)
	queue_free()
	pass
