class_name InventroyUI extends Control

const INVENTORY_SLOT = preload("res://GUI/PlayerMenu/Inventory/inventory_slot.tscn")

@export var data : InventoryData


func _ready() -> void:
	PlayerMenu.shown.connect(update_inventory)
	PlayerMenu.hidden.connect(clear_inventory)
	clear_inventory()
	pass


func clear_inventory() -> void:
	# Kill all the inventory items.
	for c in get_children():
		c.queue_free()
	pass

func update_inventory() -> void:
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
	
	get_child(0).grab_focus() # might not be needed
