extends PanelContainer

const Slot = preload("res://Inventory/slot.tscn")

@onready var item_grid: GridContainer = $MarginContainer/ItemGrid

func set_inv_data(inv_data: InventoryData):
	inv_data.inv_updated.connect(build_item_grid)
	build_item_grid(inv_data)
	


func build_item_grid(inv_data: InventoryData):
	for child in item_grid.get_children():
		child.queue_free()
		
	for slot_data in inv_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_click.connect(inv_data.on_slot_clicked)
		
		if slot_data:
			slot.get_slot_data(slot_data)

