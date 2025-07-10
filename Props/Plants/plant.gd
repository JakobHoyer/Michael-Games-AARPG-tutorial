class_name Plant extends Node2D

func _ready() -> void:
	$HitBox.damaged.connect(take_damage)
	pass


func take_damage(_hurt_box : HurtBox) -> void:
	queue_free() # this tells godot to get ready to remove object from game
	pass
