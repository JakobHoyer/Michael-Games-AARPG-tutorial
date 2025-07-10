class_name HurtBox extends Area2D

@export var damage : int = 1

func _ready() -> void:
	area_entered.connect(area_is_entered) 
	pass

func _process(_delta: float) -> void:
	pass


func area_is_entered( area : Area2D) -> void:
	if area is HitBox:
		area.take_damage(self)
	pass
