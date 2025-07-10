extends CanvasLayer

signal shown
signal hidden

var is_paused : bool = false

@onready var item_description: Label = $Control/ItemDescription


func _ready() -> void:
	hide_player_menu()
	pass


# takes any unhandled input (from other scripts) and tries to handle it.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_menu"):
		if is_paused == false:
			show_player_menu()
		else:
			hide_player_menu()
		get_viewport().set_input_as_handled() # make sure multiple scripts doesn't try to handle unhandled event
		pass


func show_player_menu() -> void:
	if PauseMenu.is_paused == true:
		return
	get_tree().paused = true
	visible = true
	is_paused = true
	shown.emit()
	pass


func hide_player_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()
	pass


func update_item_description(new_text : String) -> void:
	item_description.text = new_text
	pass
