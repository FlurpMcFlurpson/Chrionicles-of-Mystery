extends Resource

class_name InventoryData

signal inv_updated(inv_data: InventoryData)
signal inv_interact(inv_data: InventoryData, index:int, button: int)

@export var slot_datas: Array[SlotData]

func on_slot_clicked(index:int, button:int) -> void:
	inv_interact.emit(self, index, button)

func held_slot_data(index:int) -> SlotData:
	var slot_data = slot_datas[index]
	if slot_data:
		slot_datas[index] = null
		inv_updated.emit(self)
		return slot_data
	else :
		return null
	
func drop_slot_data(held_slot_data: SlotData,index:int) -> SlotData:
	var slot_data = slot_datas[index]
	
	var return_slot_data: SlotData
	if slot_data and slot_data.can_merge_all_with(held_slot_data):
		slot_data.merge_with(held_slot_data)
	else:
		slot_datas[index] = held_slot_data
		return_slot_data = slot_data
	
	inv_updated.emit(self)
	return return_slot_data

func drop_single_slot_data(held_slot_data: SlotData,index:int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		slot_datas[index] = held_slot_data.make_single_slot()
	elif slot_data.can_merge_with(held_slot_data):
		slot_data.merge_with(held_slot_data.make_single_slot())
		
	inv_updated.emit(self)
		
	if held_slot_data.quantity > 0:
		return held_slot_data
	else:
		return null
		
func item_drop(slot_data: SlotData) -> bool:
	
	for index in slot_datas.size():
		if not slot_datas[index]:
			slot_datas[index] = slot_data
			inv_updated.emit(self)
			return true
	return false

func use_slot_data(index: int):
	var slot_data = slot_datas[index]
	if not slot_data:
		return
		
	if slot_data.item_data is Health_item:
		slot_data.quantity -= 1
		if slot_data.quantity <= 0:
			slot_datas[index] = null
	#(slot_data.item_data.Item_name)
	PlayerState.use_slot_data(slot_data)
	inv_updated.emit(self)
