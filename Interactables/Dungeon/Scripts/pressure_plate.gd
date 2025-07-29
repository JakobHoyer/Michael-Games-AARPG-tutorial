class_name PressurePlate extends Node2D

signal activated
signal deactivated

@export var audio_activate : AudioStream
@export var audio_deactivate : AudioStream

var bodies : int = 0
var is_active : bool = false
var off_rect : Rect2

@onready var area_2d: Area2D = $Area2D
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	off_rect = sprite_2d.region_rect


func _on_body_entered(body : Node2D) -> void:
	bodies += 1
	check_is_activated()


func _on_body_exited(body : Node2D) -> void:
	bodies -= 1
	check_is_activated()


func check_is_activated() -> void:
	if bodies > 0 and is_active == false:
		is_active = true
		sprite_2d.region_rect.position.x = off_rect.position.x - 32
		play_audio(audio_activate)
		activated.emit()
		
	elif bodies <= 0 and is_active == true:
		is_active = false
		sprite_2d.region_rect.position.x = off_rect.position.x
		play_audio(audio_deactivate)
		deactivated.emit()


func play_audio(_stream : AudioStream) -> void:
	audio.stream = _stream
	audio.play()
