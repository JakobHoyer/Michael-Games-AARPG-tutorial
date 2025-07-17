@tool
class_name ItemPickup extends CharacterBody2D

@export var item_data : ItemData : set = _set_item_data

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	 
	_update_texture()
	if Engine.is_editor_hint(): # this makes the next lines not run if in game
		return
	area_2d.body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	# make item bounce on wall impact
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	velocity -= velocity * delta * 4


func _on_body_entered(b) -> void:
	if b is Player:
		if item_data:
			if PlayerManager.INVENTORY_DATA.add_item(item_data) == true:
				item_picked_up()


func item_picked_up() -> void:
	area_2d.body_entered.disconnect(_on_body_entered) # dont want to pick up item again
	audio_stream_player_2d.play()
	visible = false # make item disapear
	await audio_stream_player_2d.finished
	queue_free() # remove item


func _set_item_data(value : ItemData) -> void:
	item_data = value
	_update_texture()


func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
