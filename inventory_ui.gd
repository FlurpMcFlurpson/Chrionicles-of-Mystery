extends ItemList


func add_slot(ID ="0"):
	var item_texture =load("res://art//items/"+ ItemData.get_texture_name(ID))
	var item_name = ItemData.get_item_name(ID)
	add_item(item_name,item_texture)


func _on_add_item_pressed():
	update_inv()

func update_inv():
	$".".add_slot(str(randi() %3))
	print("updated_items")



func _on_item_activated(index):
	pass
