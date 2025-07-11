class_name InventoryData extends Resource

@export var slots : Array[SlotData]

func _init() -> void:
	connect_slots()


func add_item(item : ItemData, count : int = 1) -> bool:
	for s in slots:
		if s: # is not null
			if s.item_data == item: # if the item is already in inventory
				s.quantity += count
				return true
	
	for i in slots.size():
		if slots[i] == null: # if slot is empty, add item
			var new_slot_data = SlotData.new()
			new_slot_data.item_data = item
			new_slot_data.quantity = count
			slots[i] = new_slot_data
			new_slot_data.changed.connect(slot_changed)
			return true
	
	print("Inventory was full!")
	return false


func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect(slot_changed)


func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect(slot_changed)
				var index = slots.find(s)
				slots[index] = null
				emit_changed()


## Gather inventory into an array to be saved
func get_save_data() -> Array:
	var item_save : Array = []
	for i in slots.size():
		item_save.append(item_to_save(slots[i]))
	return item_save

## Convert each inventory item into a dictionary
func item_to_save(slot : SlotData) -> Dictionary:
	var result = {item = "", quantity = 0}
	if slot != null:
		if slot.item_data != null:
			result.quantity = slot.quantity
			result.item = slot.item_data.resource_path
		
	return result


func parse_save_data(save_data : Array) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize(array_size) # refill array will null
	for i in save_data.size():
		slots[i] = item_from_save(save_data[i])
	connect_slots()


func item_from_save(save_object : Dictionary) -> SlotData:
	if save_object.item == "":
		return null
	var new_slot : SlotData = SlotData.new()
	new_slot.item_data = load(save_object.item)
	new_slot.quantity = int(save_object.quantity)
	return new_slot
