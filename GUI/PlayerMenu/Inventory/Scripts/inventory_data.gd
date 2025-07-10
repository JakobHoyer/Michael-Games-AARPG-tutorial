class_name InventoryData extends Resource

@export var slots : Array[SlotData]

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
			return true
	
	print("Inventory was full!")
	return false
