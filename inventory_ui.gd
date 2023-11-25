
extends ItemList

@export var Item_data: Resource

func add_slot(ID ="0"):
	var item_texture =Item_data.getTexture()
	var item_name = Item_data.getName()
	add_item(item_name,item_texture)


func _on_add_item_pressed():
	update_inv()

func update_inv():
	$".".add_slot(str(randi() %3))
	print("updated_items")



func _on_item_activated(index):
	pass
