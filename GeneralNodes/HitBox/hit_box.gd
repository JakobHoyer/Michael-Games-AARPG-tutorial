class_name HitBox extends Area2D

signal damaged(hurt_box : HurtBox) # signal for communicating with other stuff

func _ready() -> void:
	pass

func _process(_delta : float) -> void:
	pass

func take_damage(hurt_box : HurtBox) -> void:
	damaged.emit(hurt_box) # send out a signal saying entity has been damaged
