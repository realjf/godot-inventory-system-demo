extends Node

signal active_item_updated

const SlotClass = preload("res://Slot.gd")
const ItemClass = preload("res://Item.gd")
const NUM_INVENTORY_SLOTS = 20
const NUM_HOTBAR_SLOTS = 8

var active_item_slot = 0

var inventory = {
	0: ["Iron Sword", 1],  #--> slot_index: [item_name, item_quantity]
	1: ["Iron Sword", 1],  #--> slot_index: [item_name, item_quantity]
	2: ["Slime Potion", 98],
	3: ["Slime Potion", 45],
}

var hotbar = {
	0: ["Iron Sword", 1],  #--> slot_index: [item_name, item_quantity]
	1: ["Iron Sword", 1],
	2: ["Iron Sword", 1],
	3: ["Slime Potion", 98],
	4: ["Iron Sword", 1],
	5: ["Iron Sword", 1],
	6: ["Iron Sword", 1],
	7: ["Iron Sword", 1],
}

var equips = {
	0: ["Brown Shirt", 1],  #--> slot_index: [item_name, item_quantity]
	1: ["Blue Jeans", 1],  #--> slot_index: [item_name, item_quantity]
	2: ["Brown Boots", 1],	
}

# First try to add to hotbar
func add_item(item_name, item_quantity) -> int:
	for item in hotbar:
		if hotbar[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - hotbar[item][1]
			if able_to_add >= item_quantity:
				hotbar[item][1] += item_quantity
				update_slot_visual(item, hotbar[item][0], hotbar[item][1], true)
				return 0
			else:
				hotbar[item][1] += able_to_add
				update_slot_visual(item, hotbar[item][0], hotbar[item][1], true)
				item_quantity = item_quantity - able_to_add
	
	for i in range(NUM_HOTBAR_SLOTS):
		if hotbar.has(i) == false:
			hotbar[i] = [item_name, item_quantity]
			update_slot_visual(i, hotbar[i][0], hotbar[i][1], true)
			return 0
	
	# if there is any remaining	
	return item_quantity
	
	
#	for item in inventory:
#		if inventory[item][0] == item_name:
#			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
#			var able_to_add = stack_size - inventory[item][1]
#			if able_to_add >= item_quantity:
#				inventory[item][1] += item_quantity
#				update_slot_visual(item, inventory[item][0], inventory[item][1])
#				return
#			else:
#				inventory[item][1] += able_to_add
#				update_slot_visual(item, inventory[item][0], inventory[item][1])
#				item_quantity = item_quantity - able_to_add
#
#
#	for i in range(NUM_INVENTORY_SLOTS):
#		if inventory.has(i) == false:
#			inventory[i] = [item_name, item_quantity]
#			update_slot_visual(i, inventory[i][0], inventory[i][1])
#			return


func update_slot_visual(slot_index, item_name, new_quantity, is_hotbar: bool = false):
	var slot: Node
	if is_hotbar:
		slot = get_tree().root.get_node("/root/World/UserInterface/Hotbar/HotbarSlots/HotbarSlot" + str(slot_index + 1))
	else:
		slot = get_tree().root.get_node("/root/World/UserInterface/Inventory/GridContainer/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)



func remove_item(slot: SlotClass):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		_:
			equips.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]
		_:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]
		

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.slot_type:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add
		_:
			equips[slot.slot_index][1] += quantity_to_add


func active_item_scroll_up():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")

func active_item_scroll_down():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")
