extends Control

var held_slot_data: SlotData
@onready var inventory = $Panel/HBoxContainer/Inventory
@onready var held_slot = $HeldSlot

func _physics_process(delta):
	if held_slot.visible:
		held_slot.global_position = get_global_mouse_position() + Vector2(5,5)

func set_player_inv_data(inv_data: InventoryData):
	inv_data.inv_interact.connect(on_inv_interact)
	inventory.set_inv_data(inv_data)
	
func on_inv_interact(inv_data: InventoryData, index:int, button: int) -> void:
	
	match [held_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			held_slot_data = inv_data.held_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			held_slot_data = inv_data.drop_slot_data(held_slot_data,index)
	
	update_held_slot()

func  update_held_slot():
	if held_slot_data: 
		held_slot.show()
		held_slot.get_slot_data(held_slot_data)
	else:
		held_slot.hide()
