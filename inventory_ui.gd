extends Panel


func _on_item_list_item_activated(index):
	print($TabContainer/Inventory/ItemList.get_item_text(index))
